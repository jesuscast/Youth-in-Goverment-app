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
    
    var backend: Backend? = nil
   
    
    // var items: [String] = ["Viper", "X", "Games"]
    
    var screenRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var screenWidth = CGFloat(0.0)
    
    var screenHeight = CGFloat(0.0)
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Setup the backend.
        backend = Backend()
        backend!.onMessage = { msg in
            //  Do something when a message is received
        }
        backend!.onError = { err in
            // Do something when an error is received.
        }
        // Set up the table view
        
        //
        screenRect = UIScreen.mainScreen().bounds
        screenWidth = screenRect.size.width
        screenHeight = screenRect.size.height
        //
        
        self.view.addSubview(nav.view)
        self.nav.pushViewController(OptionsViewController(), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



