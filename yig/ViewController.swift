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


// MARK - State Machine Definitions
enum StatesApp:Equatable {
    case Map
    case Docket
    case BillUpdates
    case Bus
    case Announcements
    case Research
    case Staff
    case Candidates
}

func ==(a: StatesApp, b:StatesApp) -> Bool{
    switch(a,b){
    case(.Map, .Map): return true
    case(.Docket, .Docket): return true
    case(.BillUpdates, .BillUpdates): return true
    case (.Bus, .Bus): return true
    case (.Announcements, .Announcements): return true
    case (.Research, .Research): return true
    case (.Staff, .Staff): return true
    case (.Candidates, .Candidates): return true
    default: return false
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var nav: UINavigationController = UINavigationController()
    
    @IBOutlet weak var options: UITableView!
    var backend: Backend? = nil
   
    
    var items: [String] = ["Map", "Docket", "Bill Updates", "Conference Schedule", "Bus Schedule", "Announcements", "Research Questions", "Staff Questions", "Candidates"]
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
        options.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // self.view.addSubview(options)
        
        //
        screenRect = UIScreen.mainScreen().bounds
        screenWidth = screenRect.size.width
        screenHeight = screenRect.size.height
        //
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = options.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
        
    }
    
    
    func activateState(stateGoal: StatesApp) {
        switch(stateGoal) {
        case .Map:
            let x = MapViewController()
            self.nav.pushViewController(x, animated: true)
        case .Docket:
            let x = DocketViewController()
            self.nav.pushViewController(x, animated: true)
        case .BillUpdates:
            let x = BillUpdatesViewController()
            self.nav.pushViewController(x, animated: true)
        case .Bus:
            let x = ConferenceScheduleViewController()
            self.nav.pushViewController(x, animated: true)
        case .Announcements:
            let x = BusScheduleViewController()
            self.nav.pushViewController(x, animated: true)
        case .Research:
            let x = AnnouncementsViewController()
            self.nav.pushViewController(x, animated: true)
        case .Staff:
            let x = StaffQuestionsViewController()
            self.nav.pushViewController(x, animated: true)
        case .Candidates:
            let x = CandidatesViewController()
            self.nav.pushViewController(x, animated: true)
        }
    }
}



