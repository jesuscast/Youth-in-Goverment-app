//
//  GroupedViewController.swift
//  yig
//
//  Created by Macbook on 10/24/15.
//  Copyright © 2015 Macbook. All rights reserved.
//

import UIKit
import Firebase
/*


class DocketViewController: UITableViewController {
    // MARK: - Properties
    var names: [ String: [(String,String)] ] = [ "Tomato": [("origin","central amerca"), ("color","red")] ] {
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
        self.view.frame         =   CGRectMake(0, 65, screenWidth, screenHeight);
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
        let vcc = ListTuplesViewController()
        var eventTemp = [("",""),("",""),("",""),("",""),("",""),("",""),("",""),("","")]
        for (keySelected, valueSelected) in detailedInformation[indexPath.section][indexPath.row] {
            var newKeyName = ""
            switch(keySelected) {
            case "formattedStartDay":
                newKeyName = "Date"
                eventTemp[1] = (newKeyName, valueSelected)
            case "eventName":
                newKeyName = "Event name"
                eventTemp[0] = (newKeyName, valueSelected)
            case "attire":
                newKeyName = "Attire"
                eventTemp[6] = (newKeyName, valueSelected)
            case "locationName":
                newKeyName = "Location"
                eventTemp[4] = (newKeyName, valueSelected)
            case "formattedStartTime":
                newKeyName = "Start time"
                eventTemp[2] = (newKeyName, valueSelected)
            case "formattedEndTime":
                newKeyName = "End time"
                eventTemp[3] = (newKeyName, valueSelected)
            case "locationAddress":
                newKeyName = "Address"
                eventTemp[5] = (newKeyName, valueSelected)
            case "description":
                newKeyName = "Description"
                eventTemp[7] = (newKeyName, valueSelected)
            default:
                print("Ignore this information")
                // eventTemp.append((keySelected,"Unknown"))
            }
        }
        vcc.names = [ "Event Information" : eventTemp ]
        print("\(self.navigationController)")
        self.navigationController?.pushViewController(vcc, animated: true)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return objectArray[section].sectionName
    }
    // MARK: - Callbacks from firebase
    func overrideFirebaseCallbacks() {
        backend.options["docketSections"] = {
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
            // Every key represents a committee
            // And every value represents the list of bill in the committee at the specifiec moment
            for (key, value) in self.firebaseData! {
                if(key != "TEST"){
                    //  Create a temporary array of tuples where we are going to store
                    // The Array retrieved from firebase
                    var tempDictToTuple = [ (String, String) ] ()
                    // Loop through the values of the json
                    for (keyInDict, valueInDict) in value {
                        // Append the key and the value as a tuple
                        tempDictToTuple.append( (keyInDict, valueInDict) )
                    }
                    // Using the temporary array of tuples create an object
                    let tempObject = Objects(sectionName: key, sectionObjects: tempDictToTuple)
                    // Append the object to the object array from where the result is created.
                    self.objectArray.append(tempObject)
                }
            }
            
            var namesTemporary:[ String : [(String,String)] ] = [ String : [(String,String)] ]()
            var detailedInformationCounter = 0
            
            self.objectArray = [Objects]()
            
            
//            // START ADD OBJECTS -----------------
//            if namesTemporary[dateStringStart] == nil {
//                namesTemporary[dateStringStart] = [(String,String)]()
//                self.detailedInformation.append( [   [(String,String)]   ]()  )
//                detailedInformationCounter += 1
//                self.objectArray.append(Objects(sectionName: dateStringStart, sectionObjects: [(String,String)]() ))
//            }
//            namesTemporary[dateStringStart]?.append(("\(timeStringStart) - \(timeStringEnd)" , "\(firebaseOrdered[i]["eventName"]!)"))
//            self.detailedInformation[detailedInformationCounter-1].append(  [(String,String)]()  )
//            self.objectArray[detailedInformationCounter-1].sectionObjects.append(("\(timeStringStart) - \(timeStringEnd)" , "\(firebaseOrdered[i]["eventName"]!)"))
//            let countTemp = self.detailedInformation[detailedInformationCounter-1].count-1
//            for (keyDetailed, valueDetailed) in firebaseOrdered[i] {
//                self.detailedInformation[detailedInformationCounter-1][countTemp].append((keyDetailed, valueDetailed))
//            }
            // END ADD OBJECTS --------------
            self.names = namesTemporary
            print("\(self.names)")
        }
    }
}
*/