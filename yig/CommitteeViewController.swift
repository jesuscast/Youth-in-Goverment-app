//
//  GroupedViewController.swift
//  yig
//
//  Created by Macbook on 10/24/15.
//  Copyright © 2015 Macbook. All rights reserved.
//

import UIKit
import Firebase



class CommitteeViewController: UITableViewController {
    // MARK: - Properties
    // Screeen variables
    var screenRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var screenWidth = CGFloat(0.0)
    
    var screenHeight = CGFloat(0.0)
    // Committee
    var committee = ""
    var names: [ String: [(String,String)] ] = ["Committees":[ ("Criminal Justice",""), ("Education",""), ("Environmental",""), ("General Issues",""), ("Healthcare and Human Services",""), ("Transportation",""), ("Governor Desk",""), ("passed legislation",""), ("vetoed legislation",""), ("Premier House",""), ("Premier Senate",""), ("House",""), ("Senate","") ] ] {
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
    
    // Backend firebase connection
    var backend = Backend()
    
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
        // set the size of the tableview
        
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
        // cell.detailTextLabel?.text = objectArray[indexPath.section].sectionObjects[indexPath.row].1
        cell.textLabel?.textColor = UIColor.whiteColor()
        //
        cell.textLabel?.font = UIFont(name: "Verdana", size: 18)
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.whiteColor().CGColor
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return objectArray[section].sectionName
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Check which option did you select
        print("You selected cell section \(indexPath.section) #\(indexPath.row)!")
        // Obtain the id of the selected bill
        let idOfSelectedBill = self.names["Bills"]![indexPath.row].1
        // Create the tuple view controller
        let vcc = BillsViewController()
        self.backend.firebaseConnection.childByAppendingPath("bills").childByAppendingPath("\(idOfSelectedBill)").observeSingleEventOfType(.Value, withBlock: {
            snapshotInternal in
            NSLog("SNAPSHOT OF THIS LOGGGG \(snapshotInternal)")
            
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
                var namesTempClean = [("",""),("",""),("",""),("",""),("",""),("",""),("",""),("","")]
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
                    case "rocketDocketStatus":
                        newKeyName = "Rocket Docket Type"
                        namesTempClean[6] = (newKeyName, valueSelected)
                    case "rocketDocketStatus":
                        newKeyName = "Rocket Docket Type"
                        namesTempClean[7] = (newKeyName, valueSelected)
                    default:
                        print("Ignore this information")
                        // eventTemp.append((keySelected,"Unknown"))
                    }
                }
                vcc.names = [ "Bill Information" : namesTempClean ]
                print("\(self.navigationController)")
                self.navigationController?.pushViewController(vcc, animated: true)

            }
        })
    }
    
    
    // MARK: - Callbacks from firebase
    func overrideFirebaseCallbacks() {
        backend.options["bills"] = {
            (snapshot: FDataSnapshot) -> Void in
            NSLog("Loading all the bills in committee \(self.committee)")
            self.backend.firebaseConnection.childByAppendingPath("bills").queryOrderedByChild("billLocation").queryEqualToValue(self.committee).observeSingleEventOfType(.Value, withBlock: {
                   snapshotInternal in
                    self.names.removeAll()
                    self.objectArray.removeAll()
                    self.names = [ String: [(String,String)] ] ()
                    self.names["Bills"] = [(String,String)]()
                    NSLog("\(snapshotInternal)")
                    if let valueOfSnapshot = snapshotInternal.value as! [ String : [String : String] ]? {
                        NSLog("The value of the snapshot is \(valueOfSnapshot)")
                        for (_, value) in valueOfSnapshot {
                            self.names["Bills"]!.append( (value["billTitle"]!, value["id"]!) )
                        } // end of for
                    }
                    for (keyNames, valueNames) in self.names {
                        // print("\(key) -> \(value)")
                        self.objectArray.append(Objects(sectionName: keyNames, sectionObjects: valueNames))
                    }
                    NSLog("Bills loaded")
                    self.tableView.reloadData()
            })
        }
    }
}