//
//  ViewController.swift
//  yig
//
//  Created by Macbook on 10/18/15.
//  Copyright © 2015 Macbook. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation


class SelectUserTypeViewController: UIViewController {
    var nav: UINavigationController = UINavigationController()
    
    var screenRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var screenWidth = CGFloat(0.0)
    
    var screenHeight = CGFloat(0.0)
    
    var splash = UIButton()
    
    var defaults = NSUserDefaults.standardUserDefaults()
    var IamDelegate = UIButton()
    var IamJudicial = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Setup the backend.
        // Set up the table view
        
        //
        screenRect = UIScreen.mainScreen().bounds
        screenWidth = screenRect.size.width
        screenHeight = screenRect.size.height
        //
        // Set up the delegate button
        IamDelegate.setTitle("Legislative branch", forState: .Normal)
        IamDelegate.layer.cornerRadius = 10
        IamDelegate.layer.borderColor = UIColor.blueColor().CGColor
        IamDelegate.layer.borderWidth = 2
        IamDelegate.addTarget(self, action: "setDelegate:", forControlEvents: .TouchUpInside)
        IamDelegate.setTitleColor(UIColor.blackColor(), forState: .Normal)
        IamDelegate.frame = CGRect(x: screenWidth*0.20, y: screenHeight*0.70, width: screenWidth*0.60, height: screenHeight*0.10)
        self.view.addSubview(IamDelegate)
        // Set up the judicial button
        IamJudicial.setTitle("Judicial branch", forState: .Normal)
        IamJudicial.layer.cornerRadius = 10
        IamJudicial.layer.borderColor = UIColor.blueColor().CGColor
        IamJudicial.layer.borderWidth = 2
        IamJudicial.addTarget(self, action: "setJudicial:", forControlEvents: .TouchUpInside)
        IamJudicial.setTitleColor(UIColor.blackColor(), forState: .Normal)
        IamJudicial.frame = CGRect(x: screenWidth*0.20, y: screenHeight*0.20, width: screenWidth*0.60, height: screenHeight*0.10)
        self.view.addSubview(IamJudicial)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func optionsScreen(sender: UIButton) {
        splash.removeFromSuperview()
        self.nav.pushViewController(OptionsViewController(), animated: true)
    }
    
    // Save the current user
    func setDelegate(sender: UIButton) {
        defaults.setValue("delegate", forKey: "userType")
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    func setJudicial(sender: UIButton) {
        defaults.setValue("judicial", forKey: "userType")
        self.navigationController?.popViewControllerAnimated(true)
    }
}



