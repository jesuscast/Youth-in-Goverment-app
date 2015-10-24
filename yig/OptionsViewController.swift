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

// MARK - State Machine Definitions
enum StatesApp:Equatable {
    case Map
    case Docket
    case BillUpdates
    case Bus
    case Announcements
    case Research
    case Candidates
    case Options
    case Schedule
    case StaffQuestions
}

func ==(a: StatesApp, b:StatesApp) -> Bool{
    switch(a,b){
    case(.Map, .Map): return true
    case(.Options, .Options): return true
    case(.Docket, .Docket): return true
    case(.BillUpdates, .BillUpdates): return true
    case (.Bus, .Bus): return true
    case (.Announcements, .Announcements): return true
    case (.Research, .Research): return true
    case (.Candidates, .Candidates): return true
    case (.Schedule, .Schedule): return true
    case (.StaffQuestions, .StaffQuestions): return true
    default: return false
    }
}

class OptionsViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    var options: UITableView  =   UITableView()
    
    var screenRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var screenWidth = CGFloat(0.0)
    
    var screenHeight = CGFloat(0.0)
    
    var items: [String] = ["Map", "Docket", "Bill Updates", "Conference Schedule", "Bus Schedule", "Announcements", "Research Questions", "Staff Questions", "Candidates"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the table view
        
        //
        screenRect = UIScreen.mainScreen().bounds
        screenWidth = screenRect.size.width
        screenHeight = screenRect.size.height
        //
        
        options.frame         =   CGRectMake(0, 100, screenWidth, screenHeight-100);
        options.delegate      =   self
        options.dataSource    =   self
        options.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(options)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        switch(indexPath.row) {
        case 0:
            self.activateState(.Map)
        case 1:
            self.activateState(.Docket)
        case 2:
            self.activateState(.BillUpdates)
        case 3:
            self.activateState(.Schedule)
        case 4:
            self.activateState(.Bus)
        case 5:
            self.activateState(.Announcements)
        case 6:
            self.activateState(.Research)
        case 7:
            self.activateState(.StaffQuestions)
        case 8:
            self.activateState(.Candidates)
        default:
            NSLog("sd")
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = options.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
        
    }
    
    func activateState(stateGoal: StatesApp) {
        var x: UIViewController = UIViewController()
        switch(stateGoal) {
        case .Options:
            x = OptionsViewController()
        case .Map:
            x = MapViewController()
        case .Docket:
            x = DocketViewController()
        case .BillUpdates:
            x = BillUpdatesViewController()
        case .Bus:
            x = BusScheduleViewController()
        case .Announcements:
            x = AnnouncementsViewController()
        case .Candidates:
            x = CandidatesViewController()
        case .StaffQuestions:
            x = StaffQuestionsViewController()
        case .Research:
            x = ResearchQuestionsViewController()
        case .Schedule:
            x = ConferenceScheduleViewController()
        }
        self.navigationController?.pushViewController(x, animated: true)
    }
}