//
//  GroupedViewController.swift
//  yig
//
//  Created by Macbook on 10/24/15.
//  Copyright © 2015 Macbook. All rights reserved.
//

import UIKit
import Firebase
class GroupedViewController: UITableViewController {
    
    // MARK: - Properties
    var names = ["Tomato": [("origin","central amerca"), ("color","red")], "apple": [("origin","europe"), ("color","red")]]
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell section \(indexPath.section) #\(indexPath.row)!")
        print("\(detailedInformation[indexPath.section][indexPath.row])")
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return objectArray[section].sectionName
    }
    // MARK: - Callbacks from firebase
    func overrideFirebaseCallbacks() {
        backend.options["conferenceSchedule"] = {
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
            var namesTemporary:[ String : [(String,String)] ] = [ String : [(String,String)] ]()
            var detailedInformationCounter = 0
            for (key, value) in self.firebaseData! {
                if key != "TEST" {
                    // Format the start day
                    var date = NSDate(timeIntervalSince1970: Double(value["startTimestamp"]!)!)
                    let dayTimePeriodFormatter = NSDateFormatter()
                    dayTimePeriodFormatter.dateFormat = "EEEE d, yyyy"
                    let dateStringStart = dayTimePeriodFormatter.stringFromDate(date)
                    self.firebaseData![key]!["formattedStartDay"] = dateStringStart
                    // Format the start time
                    dayTimePeriodFormatter.dateFormat = "h:mm a"
                    let timeStringStart = dayTimePeriodFormatter.stringFromDate(date)
                    self.firebaseData![key]!["formattedStartTime"] = timeStringStart
                    
                    // Format the end day
                    date = NSDate(timeIntervalSince1970: Double(value["endTimestamp"]!)!)
                    dayTimePeriodFormatter.dateFormat = "EEEE d, yyyy"
                    let dateStringEnd = dayTimePeriodFormatter.stringFromDate(date)
                    self.firebaseData![key]!["formattedEndDay"] = dateStringEnd
                    // Format the end time
                    dayTimePeriodFormatter.dateFormat = "h:mm a"
                    let timeStringEnd = dayTimePeriodFormatter.stringFromDate(date)
                    self.firebaseData![key]!["formattedEndTime"] = timeStringEnd
                    // Check if namesTemp Contains the specified day
                    if namesTemporary[dateStringStart] == nil {
                        namesTemporary[dateStringStart] = [(String,String)]()
                        self.detailedInformation.append( [   [(String,String)]   ]()  )
                        detailedInformationCounter += 1
                    }
                    namesTemporary[dateStringStart]?.append(("\(timeStringStart) - \(timeStringEnd)" , "\(self.firebaseData![key]!["eventName"]!)"))
                    self.detailedInformation[detailedInformationCounter-1].append(  [(String,String)]()  )
                    let countTemp = self.detailedInformation[detailedInformationCounter-1].count-1
                    for (keyDetailed, valueDetailed) in self.firebaseData![key]! {
                        self.detailedInformation[detailedInformationCounter-1][countTemp].append((keyDetailed, valueDetailed))
                    }
                }
            }
            self.names = namesTemporary
            print("\(self.names)")
            // var namesTemp:[ String : [String:String] ]
            self.objectArray = [Objects]()
            for (key, value) in self.names {
                print("\(key) -> \(value)")
                self.objectArray.append(Objects(sectionName: key, sectionObjects: value))
            }
            
            self.tableView.reloadData()
            // print("\(self.firebaseData)")
        }
    }
}