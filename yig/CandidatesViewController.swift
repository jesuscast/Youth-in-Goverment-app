//
//  GroupedViewController.swift
//  yig
//
//  Created by Macbook on 10/24/15.
//  Copyright © 2015 Macbook. All rights reserved.
//

import UIKit
import Firebase



class CandidatesViewController: UITableViewController {
    var goAhead = false
    
    var screenRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var screenWidth = CGFloat(0.0)
    
    var screenHeight = CGFloat(0.0)
    
    var backend = Backend()
    // MARK: - Properties
    var names: [ String: [(String,String)] ] = ["Tomato": [("origin","central amerca"), ("color","red")], "apple": [("origin","europe"), ("color","red")]] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var offices: [ String ] = [
        "Governor",
        "Lieutenant Governor",
        "Speaker of the House",
        "Secretary of State",
        "Attorney General",
    ]
    
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
    
    // MARK: - Override firebase callbacks
    func overrideFirebaseCallbacks() {
        
        backend.options["candidates"] = {
            (snapshot: FDataSnapshot) -> Void in
            // First organize all of these objects into groups
            var temporaryDataForOffices: [ String : [(String, String)] ] = [
                "Governor": [(String, String)](),
                "Lieutenant Governor": [(String, String)](),
                "Speaker of the House": [(String, String)](),
                "Secretary of State": [(String, String)](),
                "Attorney General": [(String, String)](),
            ]
            // Loop through all the candidates
            NSLog("\(snapshot.value)")
            self.names.removeAll()
            self.objectArray.removeAll()
            if let valueOfSnapshot = snapshot.value as! [ String : [String : String] ]? {
                // Loop through all the information of the candidates
                for (keyCandidateData, valueCandidateData) in valueOfSnapshot {
                    switch(valueCandidateData["office"]!) {
                    case "Governor":
                        //
                        temporaryDataForOffices["Governor"]!.append((valueCandidateData["name"]!,keyCandidateData))
                    case "Lieutenant Governor":
                        //
                        temporaryDataForOffices["Lieutenant Governor"]!.append((valueCandidateData["name"]!,keyCandidateData))
                    case "Speaker of the House":
                        //
                        temporaryDataForOffices["Speaker of the House"]!.append((valueCandidateData["name"]!,keyCandidateData))
                    case "Secretary of State":
                        //
                        temporaryDataForOffices["Secretary of State"]!.append((valueCandidateData["name"]!,keyCandidateData))
                    case "Attorney General":
                        //
                        temporaryDataForOffices["Attorney General"]!.append((valueCandidateData["name"]!,keyCandidateData))
                    default:
                        NSLog("Ignoring this statement")
                        // create a click button that is going to extract all of the information
                        // and send to the listtuplesviewcontroller
                    }
                }
                for (key, value) in temporaryDataForOffices {
                    // print("\(key) -> \(value)")
                    self.objectArray.append(Objects(sectionName: key, sectionObjects: value))
                }
                self.goAhead = true
                self.names = temporaryDataForOffices
                
            }
        }
    }
    // MARK: - Obtain individual candidates
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (goAhead == true) {
        // Check which option did you select
        print("You selected cell section \(indexPath.section) #\(indexPath.row)!")
        // Obtain the id of the selected bill
        let idOfSelectedBill = self.objectArray[indexPath.section].sectionObjects[indexPath.row].1
        // self.names[offices[indexPath.section]]![indexPath.row].1
        // Create the tuple view controller
        let vcc = ListTuplesViewController()
        self.backend.firebaseConnection.childByAppendingPath("candidates").childByAppendingPath("\(idOfSelectedBill)").observeSingleEventOfType(.Value, withBlock: {
            snapshotInternal in
            NSLog("SNAPSHOT OF THIS LOGGGG \(snapshotInternal)")
            
            var namesTemp = [ String : [(String , String)] ]()
            namesTemp["Candidate Information"] = [(String , String)]()
            if let valueOfSnapshot = snapshotInternal.value as! [String : String]? {
                NSLog("The value of the snapshot is \(valueOfSnapshot)")
                for (elememntInBillName, elementInBill) in valueOfSnapshot {
                    namesTemp["Candidate Information"]?.append( (elememntInBillName, elementInBill) )
                    
                }
                NSLog("NAMES BEFORE CLEANING: \(namesTemp)")
                // NOW filter the namesTemp and substitute for the labels I want
                // Then after filtering it. Push the Tuple View Controller
                //------------------------
                var namesTempClean = [("",""),("",""),("",""),("",""),("",""),("",""),("",""),("",""),("",""),("","")]
                for (keySelected, valueSelected) in namesTemp["Candidate Information"]! {
                    var newKeyName = ""
                    switch(keySelected) {
                        // Information about the bill
                    case "name":
                        newKeyName = "Name"
                        namesTempClean[0] = (newKeyName, valueSelected)
                    case "office":
                        newKeyName = "Running for"
                        namesTempClean[1] = (newKeyName, valueSelected)
                        // Information about the authors
                    case "party":
                        newKeyName = "Political Party"
                        namesTempClean[2] = (newKeyName, valueSelected)
                    case "slogan":
                        newKeyName = "Slogan"
                        namesTempClean[3] = (newKeyName, valueSelected)
                    case "school":
                        newKeyName = "School"
                        namesTempClean[4] = (newKeyName, valueSelected)
                    case "statement":
                        newKeyName = "Statement"
                        namesTempClean[5] = (newKeyName, valueSelected)
                    case "graduation-year":
                        newKeyName = "Graduation year"
                        namesTempClean[6] = (newKeyName, valueSelected)
                    case "conference-role":
                        newKeyName = "This year's role"
                        namesTempClean[7] = (newKeyName, valueSelected)
                    default:
                        print("Ignore this information")
                        // eventTemp.append((keySelected,"Unknown"))
                    }
                }
                vcc.names = [ "Candidate Information" : namesTempClean ]
                print("\(self.navigationController)")
                self.navigationController?.pushViewController(vcc, animated: true)
                
            }
        })
    } // end of goAhead == true
    }
    
}