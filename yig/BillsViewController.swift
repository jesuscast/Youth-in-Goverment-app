//
//  GroupedViewController.swift
//  yig
//
//  Created by Macbook on 10/24/15.
//  Copyright © 2015 Macbook. All rights reserved.
//

import UIKit
import Firebase



class BillsViewController: UIViewController {
    var screenRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var screenWidth = CGFloat(0.0)
    
    var screenHeight = CGFloat(0.0)
    
    var billTable = ListTuplesViewController()
    
    var viewBillButton = UIButton()
    // MARK: - Properties
    var names: [ String: [(String,String)] ] = ["Tomato": [("origin","central amerca"), ("color","red")], "apple": [("origin","europe"), ("color","red")]] {
        didSet {
            billTable.names = names
            // self.tableView.reloadData()
        }
    }
    
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
        // Add the billTable to the view
        billTable.view.frame = CGRectMake(0, 65, screenWidth, screenHeight*0.7);
        self.view.addSubview(billTable.view)
        // Configure the sample buttontxt
        viewBillButton.setTitle("Read Bill", forState: .Normal)
        viewBillButton.backgroundColor = UIColor(red:0.11, green:0.64, blue:0.56, alpha:1.0)
        viewBillButton.layer.cornerRadius = 10
        viewBillButton.addTarget(self, action: "viewBill:", forControlEvents: .TouchUpInside)
        viewBillButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        viewBillButton.titleLabel!.font = UIFont(name: "Verdana", size: 18)
        viewBillButton.frame.size.width = 100
        viewBillButton.frame.size.height = screenHeight*0.1
        viewBillButton.frame.origin.y = screenHeight * 0.75 + screenHeight*0.1
        viewBillButton.frame.origin.x = screenWidth * 0.5 - 50
        viewBillButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.view.addSubview(viewBillButton)
        // viewBillButton.autoAlignAxis(.Horizontal, toSameAxisOfView: viewBillButton.superview!)
        // viewBillButton.autoConstrainAttribute(.Top, toAttribute: .Bottom, ofView: billTable.view)
        
    }
    
    func viewBill(sender: UIButton) {
    
    }
    
}