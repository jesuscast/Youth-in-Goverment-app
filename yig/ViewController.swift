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


class ViewController: UIViewController {
    var nav: UINavigationController = UINavigationController()
    
  
   
    
    // var items: [String] = ["Viper", "X", "Games"]
    
    var screenRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var screenWidth = CGFloat(0.0)
    
    var screenHeight = CGFloat(0.0)
   
    var splash = UIButton()
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
        NSLog("\(UIDevice.currentDevice().identifierForVendor!.UUIDString)")
        self.view.addSubview(nav.view)
        splash.frame = CGRect(x: 0, y: 0, width: screenWidth+10, height: screenHeight)
        splash.setBackgroundImage(UIImage(named: "splash.png"), forState: .Normal)
        splash.addTarget(self, action: "optionsScreen:", forControlEvents: .TouchUpInside)
        self.view.addSubview(splash)
        //self.nav.pushViewController(OptionsViewController(), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func optionsScreen(sender: UIButton) {
        splash.removeFromSuperview()
        self.nav.pushViewController(OptionsViewController(), animated: true)
    }
}



