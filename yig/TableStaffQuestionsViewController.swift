//
//  GroupedViewController.swift
//  yig
//
//  Created by Macbook on 10/24/15.
//  Copyright © 2015 Macbook. All rights reserved.
//

import UIKit
import Firebase



class TableStaffQuestionsViewController: UITableViewController {
    // MARK: - Properties
    var names: [ String: [(String,String)] ] = ["Tomato": [("origin","central amerca"), ("color","red")], "apple": [("origin","europe"), ("color","red")]] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var screenRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var screenWidth = CGFloat(0.0)
    
    var screenHeight = CGFloat(0.0)
    
    var firebaseData: [String: [ String : String ] ]? = nil
    var backend = Backend()
    var detailedDataMatchingNames: [ [ ( String , String ) ] ]? = nil
    
    // This define the structure of the view table with sections.
    struct Objects {
        
        var sectionName : String!
        var sectionObjects : [(String,String)]!
        
    }
    
    struct firebaseElement {
        var key: String!
        var data: [String:String]!
    }
    // An array of sections
    var objectArray = [Objects]()
    var detailedInformation:[ [   [(String,String)]   ] ] = [ [   [(String,String)]   ] ]()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        screenRect = UIScreen.mainScreen().bounds
        screenWidth = screenRect.size.width
        screenHeight = screenRect.size.height
        //
        self.view.frame         =   CGRectMake(0, 0, screenWidth, screenHeight);
        for (key, value) in names {
            // print("\(key) -> \(value)")
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
        }
        // self.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        overrideFirebaseCallbacks()
        backend.registerListeners()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return objectArray.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray[section].sectionObjects.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        // Configure the cell...
        cell.textLabel?.text = objectArray[indexPath.section].sectionObjects[indexPath.row].1
        cell.detailTextLabel?.text = objectArray[indexPath.section].sectionObjects[indexPath.row].0
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return objectArray[section].sectionName
    }
    // MARK: - Callbacks from firebase
    func overrideFirebaseCallbacks() {
        backend.options["staffQuestions"] = {
            (snapshot: FDataSnapshot) -> Void in
            if let valueOfSnapshot = snapshot.value as! [ String : [String : String] ]? {
                for (key, value) in valueOfSnapshot {
                    if (self.firebaseData==nil) {
                        self.firebaseData = ["TEST":["HELLO":"NOTHING"]]
                    }
                    if self.firebaseData![key] == nil {
                        self.firebaseData![key] = value
                    }
                }
            }
            
            var firebaseOrdered:[ [String:String] ] = [ [String:String] ]()
            for (key, value) in self.firebaseData! {
                if(key != "TEST"){
                    firebaseOrdered.append(value)
                }
            }
            for var i = 0; i<firebaseOrdered.count; i++ {
                for var j = i+1; j < firebaseOrdered.count; j++ {
                    if (Int(firebaseOrdered[i]["sentTimestamp"]!) > Int(firebaseOrdered[j]["sentTimestamp"]!)) {
                        let tempVal = firebaseOrdered[j]
                        firebaseOrdered[j] = firebaseOrdered[i]
                        firebaseOrdered[i] = tempVal
                    }
                }
            }
            
            var namesTemporary:[ String : [(String,String)] ] = [ String : [(String,String)] ]()
            var detailedInformationCounter = 0
            
            self.objectArray = [Objects]()
            for var i = 0; i<firebaseOrdered.count; i++ {
                // Format the start day
                var date = NSDate(timeIntervalSince1970: Double(firebaseOrdered[i]["sentTimestamp"]!)!)
                let dayTimePeriodFormatter = NSDateFormatter()
                dayTimePeriodFormatter.dateFormat = "EEEE d, yyyy"
                let dateStringStart = dayTimePeriodFormatter.stringFromDate(date)
                firebaseOrdered[i]["formattedSentDay"] = dateStringStart
                // Format the start time
                dayTimePeriodFormatter.dateFormat = "h:mm a"
                let timeStringStart = dayTimePeriodFormatter.stringFromDate(date)
                firebaseOrdered[i]["formattedSentTime"] = timeStringStart
                
                if namesTemporary[dateStringStart] == nil {
                    namesTemporary[dateStringStart] = [(String,String)]()
                    self.detailedInformation.append( [   [(String,String)]   ]()  )
                    detailedInformationCounter += 1
                    self.objectArray.append(Objects(sectionName: dateStringStart, sectionObjects: [(String,String)]() ))
                }
                // Append the question
                namesTemporary[dateStringStart]?.append(("\(timeStringStart)" , "\(firebaseOrdered[i]["question"]!)"))
                self.objectArray[detailedInformationCounter-1].sectionObjects.append(("\(timeStringStart)" , "\(firebaseOrdered[i]["question"]!)"))
                // Check if there is an answer
                if (firebaseOrdered[i]["answer"] != nil) {
                    if (firebaseOrdered[i]["answer"] != "" ) {
                        namesTemporary[dateStringStart]?.append(("\(timeStringStart)" , "\(firebaseOrdered[i]["answer"]!)"))
                        self.objectArray[detailedInformationCounter-1].sectionObjects.append(("\(timeStringStart)" , "\(firebaseOrdered[i]["answer"]!)"))
                    }
                }
            }
            self.names = namesTemporary
            print("\(self.names)")
        }
    }
}