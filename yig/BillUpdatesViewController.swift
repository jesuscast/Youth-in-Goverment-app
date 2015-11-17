//
//  GroupedViewController.swift
//  yig
//
//  Created by Macbook on 10/24/15.
//  Copyright © 2015 Macbook. All rights reserved.
//

import UIKit
import Firebase



class BillUpdatesViewController: UIViewController {
    var screenRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var screenWidth = CGFloat(0.0)
    
    var screenHeight = CGFloat(0.0)
    
    var backend = Backend()
    
    var defaults = NSUserDefaults.standardUserDefaults()
    
    var idOfSelectedBill = "-K3LbDlY64rhV8OTz61L"
    
    var tuplesVC = ListTuplesViewController()
    
    
    // MARK: - Properties
    var names: [ String: [(String,String)] ] = ["Tomato": [("origin","central amerca"), ("color","red")], "apple": [("origin","europe"), ("color","red")]] {
        didSet {
            tuplesVC.objectArray.removeAll()
            for (key, value) in names {
                // print("\(key) -> \(value)")
                tuplesVC.objectArray.append(ListTuplesViewController.Objects(sectionName: key, sectionObjects: value))
            }
            tuplesVC.names = names
            tuplesVC.tableView.frame.size.height = tuplesVC.tableView.contentSize.height
            tuplesVC.view.frame.size.height = tuplesVC.tableView.frame.size.height
        }
    }
    // This define the structure of the view table with sections.
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        screenRect = UIScreen.mainScreen().bounds
        screenWidth = screenRect.size.width
        screenHeight = screenRect.size.height
        //
        self.view.frame         =   CGRectMake(0, 65, screenWidth, screenHeight + 700);
        self.view.backgroundColor = UIColor(red:0.15, green:0.67, blue:0.89, alpha:1.0)
        // Add the view of the bill controller
        tuplesVC.view.frame = self.view.frame
        self.view.addSubview(tuplesVC.view)
        overrideFirebaseCallbacks()
        backend.registerListeners()
    }

    
    // MARK: - Override callbacks from firebase
    func overrideFirebaseCallbacks() {
        if (defaults.objectForKey("savedId") != nil) {
            idOfSelectedBill = defaults.valueForKey("savedId")! as! String
            self.backend.firebaseConnection.childByAppendingPath("bills").childByAppendingPath("\(idOfSelectedBill)").observeSingleEventOfType(.Value, withBlock: {
                snapshotInternal in
                NSLog("SNAPSHOT OF THIS LOGGGG \(self.idOfSelectedBill)")
                self.names.removeAll()
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
                        case "rocketDocketStatus":
                            newKeyName = "Rocket Docket Type"
                            namesTempClean[7] = (newKeyName, valueSelected)
                        case "sponsor":
                            newKeyName = "Sponsor"
                            namesTempClean[8] = (newKeyName, valueSelected)
                        default:
                            print("Ignore this information")
                            // eventTemp.append((keySelected,"Unknown"))
                        }
                    }
                    self.names = [ "Bill Information" : namesTempClean ]
                    
                }
            })
        }
        else {
            self.names = [ "Bill Information" : [("Please select a bill","")] ]
        }
    }
    
}