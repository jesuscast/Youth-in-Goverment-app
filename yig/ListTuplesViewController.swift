//
//  GroupedViewController.swift
//  yig
//
//  Created by Macbook on 10/24/15.
//  Copyright © 2015 Macbook. All rights reserved.
//

import UIKit
import Firebase



class ListTuplesViewController: UITableViewController {
    var screenRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var screenWidth = CGFloat(0.0)
    
    var screenHeight = CGFloat(0.0)
    
    
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
        // tryhing to set up the size of the table view
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
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
        //
        cell.detailTextLabel?.font = UIFont(name: "Verdana", size: 18)
        cell.detailTextLabel?.textAlignment = NSTextAlignment.Center
        cell.textLabel?.font = UIFont(name: "Verdana", size: 18)
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.whiteColor().CGColor
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        // This is terrible for performance but trying to set constrains in here.
        cell.textLabel?.autoConstrainAttribute(.Top, toAttribute: .Top, ofView: cell.contentView)
        cell.textLabel?.autoConstrainAttribute(.Left, toAttribute: .Left, ofView: cell.contentView)
        cell.textLabel?.autoConstrainAttribute(.Right, toAttribute: .Right, ofView: cell.contentView)
        cell.textLabel?.autoConstrainAttribute(.Bottom, toAttribute: .Top, ofView: cell.detailTextLabel!)
        cell.detailTextLabel?.autoConstrainAttribute(.Bottom, toAttribute: .Bottom, ofView: cell.contentView)
        cell.detailTextLabel?.autoConstrainAttribute(.Top, toAttribute: .Bottom, ofView: cell.textLabel!)
        // set the width
        cell.detailTextLabel?.autoConstrainAttribute(.Left, toAttribute: .Left, ofView: cell.contentView)
        cell.detailTextLabel?.autoConstrainAttribute(.Right, toAttribute: .Right, ofView: cell.contentView)
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return objectArray[section].sectionName
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}