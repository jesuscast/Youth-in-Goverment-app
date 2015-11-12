//
//  GroupedViewController.swift
//  yig
//
//  Created by Macbook on 10/24/15.
//  Copyright © 2015 Macbook. All rights reserved.
//

import UIKit
import Firebase



class BillUpdatesViewController: UITableViewController {
    var screenRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var screenWidth = CGFloat(0.0)
    
    var screenHeight = CGFloat(0.0)
    
    var backend = Backend()
    
    var defaults = NSUserDefaults.standardUserDefaults()
    
    var idOfSelectedBill = "-JwEDsoyuSGOIAvAeTym"
    // MARK: - Properties
    var names: [ String: [(String,String)] ] = ["Tomato": [("origin","central amerca"), ("color","red")], "apple": [("origin","europe"), ("color","red")]] {
        didSet {
            self.tableView.reloadData()
        }
    }
    // This define the structure of the view table with sections.
    struct Objects {
        
        var sectionName : String!
        var sectionObjects : [(String,String)]!
        
    }
    
    // An array of sections
    var objectArray = [Objects]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        screenRect = UIScreen.mainScreen().bounds
        screenWidth = screenRect.size.width
        screenHeight = screenRect.size.height
        //
        self.view.frame         =   CGRectMake(0, 65, screenWidth, screenHeight);
        self.view.backgroundColor = UIColor(red:0.15, green:0.67, blue:0.89, alpha:1.0)
        for (key, value) in names {
            // print("\(key) -> \(value)")
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
        }
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
        cell.textLabel?.text = objectArray[indexPath.section].sectionObjects[indexPath.row].0
        cell.detailTextLabel?.text = objectArray[indexPath.section].sectionObjects[indexPath.row].1
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.detailTextLabel?.textColor = UIColor.whiteColor()
        cell.detailTextLabel?.font = UIFont(name: "Verdana", size: 18)
        cell.detailTextLabel?.textAlignment = NSTextAlignment.Center
        cell.textLabel?.font = UIFont(name: "Verdana", size: 18)
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.whiteColor().CGColor
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return objectArray[section].sectionName
    }
    
    // MARK: - Override callbacks from firebase
    func overrideFirebaseCallbacks() {
        if (defaults.objectForKey("savedId") != nil) {
            idOfSelectedBill = defaults.valueForKey("savedId")! as! String
        }
        else {
            idOfSelectedBill = "-JwEDsoyuSGOIAvAeTym"
        }
        self.backend.firebaseConnection.childByAppendingPath("bills").childByAppendingPath("\(idOfSelectedBill)").observeSingleEventOfType(.Value, withBlock: {
            snapshotInternal in
            NSLog("SNAPSHOT OF THIS LOGGGG \(snapshotInternal)")
            self.names.removeAll()
            self.objectArray.removeAll()
            var namesTemp = [ String : [(String , String)] ]()
            namesTemp["Bill Information"] = [(String , String)]()
            if let valueOfSnapshot = snapshotInternal.value as! [String : String]? {
                NSLog("The value of the snapshot is \(valueOfSnapshot)")
                for (elememntInBillName, elementInBill) in valueOfSnapshot {
                    namesTemp["Bill Information"]?.append( (elememntInBillName, elementInBill) )
                    
                }
                NSLog("NAMES BEFORE CLEANING: \(namesTemp)")
                // NOW filter the namesTemp and substitute for the labels I want
                // Then after filtering it. Push the Tuple View Controller
                //------------------------
                var namesTempClean = [("",""),("",""),("",""),("",""),("",""),("",""),("",""),("",""),("",""),("","")]
                for (keySelected, valueSelected) in namesTemp["Bill Information"]! {
                    var newKeyName = ""
                    switch(keySelected) {
                        // Information about the bill
                    case "billStatus":
                        newKeyName = "Status of the Bill"
                        namesTempClean[0] = (newKeyName, valueSelected)
                    case "billLocation":
                        newKeyName = "Bill Current Location"
                        namesTempClean[1] = (newKeyName, valueSelected)
                        // Information about the authors
                    case "billTitle":
                        newKeyName = "Title"
                        namesTempClean[2] = (newKeyName, valueSelected)
                    case "author1":
                        newKeyName = "Co-author A"
                        namesTempClean[3] = (newKeyName, valueSelected)
                    case "author2":
                        newKeyName = "Co-author B"
                        namesTempClean[4] = (newKeyName, valueSelected)
                    case "school":
                        newKeyName = "School"
                        namesTempClean[5] = (newKeyName, valueSelected)
                    case "division":
                        newKeyName = "Division"
                        namesTempClean[6] = (newKeyName, valueSelected)
                    case "governorEvaluation":
                        newKeyName = "Governor's Evaluation"
                        namesTempClean[7] = (newKeyName, valueSelected)
                    case "rocketDocketStatus":
                        newKeyName = "Rocket Docket Type"
                        namesTempClean[8] = (newKeyName, valueSelected)
                    case "rocketDocketStatus":
                        newKeyName = "Rocket Docket Type"
                        namesTempClean[9] = (newKeyName, valueSelected)
                    default:
                        print("Ignore this information")
                        // eventTemp.append((keySelected,"Unknown"))
                    }
                }
                namesTemp["Bill Information"] = namesTempClean
                for (key, value) in namesTemp {
                    // print("\(key) -> \(value)")
                    self.objectArray.append(Objects(sectionName: key, sectionObjects: value))
                }
                self.names = [ "Bill Information" : namesTempClean ]
            }
        })
    }
    
}