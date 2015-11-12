//
//  GroupedViewController.swift
//  yig
//
//  Created by Macbook on 10/24/15.
//  Copyright © 2015 Macbook. All rights reserved.
//

import UIKit
import Firebase



class DocketViewController: UITableViewController {
    // MARK: - Properties
    // Screeen variables
    var screenRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var screenWidth = CGFloat(0.0)
    
    var screenHeight = CGFloat(0.0)
    
    var names: [ String: [(String,String)] ] = ["Committees":[ ("Governor Desk","Governor Desk"), ("passed legislation","Passed Legislation"), ("vetoed legislation","Vetoed Legislation"), ("Criminal Justice","Criminal Justice"), ("Education","Education"), ("Environmental","Environmental"), ("General Issues","General Issues"), ("Healthcare and Human Services","Healthcare and Human Services"), ("Transportation","Transportation") ] ] {
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
        self.view.backgroundColor = UIColor(red:0.15, green:0.67, blue:0.89, alpha:1.0)
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
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont(name: "Verdana", size: 18)
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.whiteColor().CGColor
        // cell.detailTextLabel?.text = objectArray[indexPath.section].sectionObjects[indexPath.row].1
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return objectArray[section].sectionName
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell section \(indexPath.section) #\(indexPath.row)!")
        let vcc = CommitteeViewController()
        vcc.committee = self.names["Committees"]![indexPath.row].0
        print("\(self.navigationController)")
        self.navigationController?.pushViewController(vcc, animated: true)
    }
}