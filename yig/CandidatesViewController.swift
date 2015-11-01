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
        cell.textLabel?.text = objectArray[indexPath.section].sectionObjects[indexPath.row].0
        // cell.detailTextLabel?.text = objectArray[indexPath.section].sectionObjects[indexPath.row].1
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
            var temporaryDataForOffices = [ String : [(String, String)] ]()
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
                        if (temporaryDataForOffices["Governor"]==nil) {
                            temporaryDataForOffices["Governor"] = [(String, String)]()
                        }
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
                    for (key, value) in temporaryDataForOffices {
                        // print("\(key) -> \(value)")
                        self.objectArray.append(Objects(sectionName: key, sectionObjects: value))
                    }
                    self.names = temporaryDataForOffices
                }
                
            }
        }
    }
}