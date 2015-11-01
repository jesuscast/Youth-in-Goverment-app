//
//  MapViewController.swift
//  yig
//
//  Created by Macbook on 10/18/15.
//  Copyright © 2015 Macbook. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MapViewController:UIViewController {
    var content = UIView()
    var imageMap = UIImageView(image: UIImage(named: "map.png"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let screenRect = UIScreen.mainScreen().bounds
        let h = screenRect.size.height
        let w = screenRect.size.width
        content.frame = CGRectMake(0, 65, w, h-65)
        content.backgroundColor = UIColor.whiteColor()
        imageMap.frame.size.width = w
        content.addSubview(imageMap)
        self.view.addSubview(content)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}