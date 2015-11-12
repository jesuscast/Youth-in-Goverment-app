//
//  GroupedViewController.swift
//  yig
//
//  Created by Macbook on 10/24/15.
//  Copyright © 2015 Macbook. All rights reserved.
//

import UIKit
import Firebase



class SettingsViewController: UITableViewController {
    var screenRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var screenWidth = CGFloat(0.0)
    
    var screenHeight = CGFloat(0.0)
    
    var backend = Backend()
    var defaults = NSUserDefaults.standardUserDefaults()
    var idOfSelectedBill = "-JwEDsoyuSGOIAvAeTym"
    // MARK: - Properties
    var names: [ String: [(String,String,String)] ] = ["Tomato": [("origin","central amerca", "a")]] {
        didSet {
            self.tableView.reloadData()
        }
    }
    // This define the structure of the view table with sections.
    struct Objects {
        
        var sectionName : String!
        var sectionObjects : [(String,String,String)]!
        
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
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return objectArray[section].sectionName
    }
    
    // MARK: - Override callbacks from firebase
    func overrideFirebaseCallbacks() {
        // Check which option did you select
        // print("You selected cell section \(indexPath.section) #\(indexPath.row)!")
        // Obtain the id of the selected bill
        // let idOfSelectedBill = self.names["Bills"]![indexPath.row].1
        // Create the tuple view controller
        self.backend.firebaseConnection.childByAppendingPath("bills").observeSingleEventOfType(.Value, withBlock: {
            snapshotInternal in
            NSLog("SNAPSHOT OF THIS LOGGGG \(snapshotInternal)")
            self.names.removeAll()
            self.objectArray.removeAll()
            var namesTemp = [ String : [(String , String, String)] ]()
            namesTemp["Delegates"] = [(String , String, String)]()
            if let valueOfSnapshot = snapshotInternal.value as! [ String : [String : String] ]? {
                for (_, arrayInfo) in valueOfSnapshot {
                    let author1 = arrayInfo["author1"]
                    let author2 = arrayInfo["author2"]
                    let id = arrayInfo["id"]
                    let title = arrayInfo["school"]
                    namesTemp["Delegates"]!.append((author1!, title!, id!))
                    namesTemp["Delegates"]!.append((author2!, title!, id!))
                }
                
                for (key, value) in namesTemp {
                    // print("\(key) -> \(value)")
                    self.objectArray.append(Objects(sectionName: key, sectionObjects: value))
                }
                self.names = namesTemp
            }
        })
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Check which option did you select
        print("You selected cell section \(indexPath.section) #\(indexPath.row)!")
        // Obtain the id of the selected bill
        let idOfSelectedBill = self.names["Delegates"]![indexPath.row].2
        defaults.setValue(idOfSelectedBill, forKey: "savedId")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}