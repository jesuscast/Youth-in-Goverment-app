//
//  GroupedViewController.swift
//  yig
//
//  Created by Macbook on 10/24/15.
//  Copyright © 2015 Macbook. All rights reserved.
//

import UIKit
import Firebase



class AnnouncementsViewController: UITableViewController {
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
    
    var defaults = NSUserDefaults.standardUserDefaults()
    
    var userType = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        screenRect = UIScreen.mainScreen().bounds
        screenWidth = screenRect.size.width
        screenHeight = screenRect.size.height
        //
        if (defaults.objectForKey("userType") != nil) {
            userType = defaults.valueForKey("userType")! as! String
        }
        self.view.frame         =   CGRectMake(0, 65, screenWidth, screenHeight);
        self.view.backgroundColor = UIColor(red:0.15, green:0.67, blue:0.89, alpha:1.0)
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
        cell.backgroundColor = UIColor(red:0.15, green:0.67, blue:0.89, alpha:1.0)
        cell.textLabel?.text = objectArray[indexPath.section].sectionObjects[indexPath.row].1
        cell.detailTextLabel?.text = objectArray[indexPath.section].sectionObjects[indexPath.row].0
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.detailTextLabel?.textColor = UIColor.whiteColor()
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return objectArray[section].sectionName
    }
    // MARK: - Callbacks from firebase
    func overrideFirebaseCallbacks() {
        var announcementsType = ""
        if (userType == "delegate") {
            announcementsType = "announcements"
        } else {
            announcementsType = "announcements2"
        }
    
        backend.options[announcementsType] = {
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
            var needsSort = true
            while (needsSort == true) {
                needsSort = false
                for var i = 0; i < (firebaseOrdered.count - 1); i++ {
                    let nextElementIsBigger = Double(firebaseOrdered[i]["timestamp"]!) < Double(firebaseOrdered[i+1]["timestamp"]!)
                    if (nextElementIsBigger) {
                        // Swap
                        let tempVal = firebaseOrdered[i+1]
                        firebaseOrdered[i+1] = firebaseOrdered[i]
                        firebaseOrdered[i] = tempVal
                        needsSort = true
                    }
                }
            }
            
            var namesTemporary:[ String : [(String,String)] ] = [ String : [(String,String)] ]()
            var detailedInformationCounter = 0
            
            self.objectArray = [Objects]()
            for var i = 0; i<firebaseOrdered.count; i++ {
                // Format the start day
                var date = NSDate(timeIntervalSince1970: Double(firebaseOrdered[i]["timestamp"]!)!)
                let dayTimePeriodFormatter = NSDateFormatter()
                dayTimePeriodFormatter.dateFormat = "EEEE d, yyyy"
                let dateStringStart = dayTimePeriodFormatter.stringFromDate(date)
                firebaseOrdered[i]["formattedStartDay"] = dateStringStart
                // Format the start time
                dayTimePeriodFormatter.dateFormat = "h:mm a"
                let timeStringStart = dayTimePeriodFormatter.stringFromDate(date)
                firebaseOrdered[i]["formattedStartTime"] = timeStringStart
                
                // Check if namesTemp Contains the specified day
                if namesTemporary[dateStringStart] == nil {
                    namesTemporary[dateStringStart] = [(String,String)]()
                    self.detailedInformation.append( [   [(String,String)]   ]()  )
                    detailedInformationCounter += 1
                    self.objectArray.append(Objects(sectionName: dateStringStart, sectionObjects: [(String,String)]() ))
                }
                namesTemporary[dateStringStart]?.append(("\(firebaseOrdered[i]["title"]!)" , "\(firebaseOrdered[i]["content"]!)"))
                self.detailedInformation[detailedInformationCounter-1].append(  [(String,String)]()  )
                self.objectArray[detailedInformationCounter-1].sectionObjects.append(("\(firebaseOrdered[i]["formattedStartTime"]!)" , "\(firebaseOrdered[i]["content"]!)"))
                let countTemp = self.detailedInformation[detailedInformationCounter-1].count-1
                for (keyDetailed, valueDetailed) in firebaseOrdered[i] {
                    self.detailedInformation[detailedInformationCounter-1][countTemp].append((keyDetailed, valueDetailed))
                }
            }
            self.names = namesTemporary
            print("\(self.names)")
        }
    }
}