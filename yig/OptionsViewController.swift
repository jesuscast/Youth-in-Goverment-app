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
    case Settings
    case SelectUser
    case ChangeToDelegate
    case ChangeToJudicial
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
    case (.Settings, .Settings): return true
    case (.SelectUser, .SelectUser): return true
        case (.ChangeToDelegate, .ChangeToDelegate): return true
        case (.ChangeToJudicial, .ChangeToJudicial): return true
    default: return false
    }
}

class OptionsViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    var options: UITableView  =   UITableView()
    
    var screenRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var screenWidth = CGFloat(0.0)
    
    var screenHeight = CGFloat(0.0)
    
    var backend = Backend()
    
    var defaults = NSUserDefaults.standardUserDefaults()
    
    var userType = ""
    var items: [String] = ["Map", "Docket", "Bill Updates", "Conference Schedule", "Bus Schedule", "Announcements", "Research Questions", "Staff Questions", "Candidates", "Settings"] {
        didSet {
            self.options.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the table view
        
        // First of all set the boundaries of the screen
        screenRect = UIScreen.mainScreen().bounds
        screenWidth = screenRect.size.width
        screenHeight = screenRect.size.height
        //
        // Now check whether the user type is saved in the database
        if (defaults.objectForKey("userType") != nil) {
            userType = defaults.valueForKey("userType")! as! String
            if (userType == "delegate") {
                items = ["Map", "Docket", "Bill Updates", "Conference Schedule", "Bus Schedule", "Announcements", "Research Questions", "Staff Questions", "Candidates", "Settings", "Change to Judicial"]
            }
            else {
                items = ["Map", "Conference Schedule", "Bus Schedule", "Announcements", "Research Questions",  "Candidates",  "Change to Delegate", "Rounds"]
            }
        }
        else {
            activateState(.SelectUser)
        }
        options.backgroundColor = UIColor(red:0.15, green:0.67, blue:0.89, alpha:1.0)
        options.frame         =   CGRectMake(0, 0, screenWidth, screenHeight);
        options.delegate      =   self
        options.dataSource    =   self
        options.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        backend.registerListeners()
        self.view.addSubview(options)
        options.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
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
        if (userType == "delegate") {
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
            case 9:
                self.activateState(.Settings)
            case 10:
                self.activateState(.ChangeToJudicial)
            default:
                NSLog("sd")
            }
        }
        else {
            switch(indexPath.row) {
            case 0:
                self.activateState(.Map)
            case 1:
                self.activateState(.Schedule)
            case 2:
                self.activateState(.Bus)
            case 3:
                self.activateState(.Announcements)
            case 4:
                self.activateState(.Research)
            case 5:
                self.activateState(.Candidates)
            case 6:
                self.activateState(.ChangeToDelegate)
            case 7:
                
                    if let url = NSURL(string: "https://yig-bill-tracker.firebaseapp.com/views/judicial/roundPairings.html") {
                        UIApplication.sharedApplication().openURL(url)
                    }
                
            default:
                NSLog("sd")
            }

        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = options.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.backgroundColor = UIColor(red:0.15, green:0.67, blue:0.89, alpha:1.0)
        cell.textLabel?.text = self.items[indexPath.row]
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont(name: "Verdana", size: 18)
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.whiteColor().CGColor
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
        case .Settings:
            x = SettingsViewController()
        case .SelectUser:
            x = SelectUserTypeViewController()
        case .ChangeToDelegate:
            x = SelectUserTypeViewController()
        case .ChangeToJudicial:
            x = SelectUserTypeViewController()
        }
        let vc = x
        pushViewController(vc, animated: true) {
            
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (self.defaults.objectForKey("userType") != nil) {
            self.userType = self.defaults.valueForKey("userType")! as! String
            if (self.userType == "delegate") {
                self.items = ["Map", "Docket", "Bill Updates", "Conference Schedule", "Bus Schedule", "Announcements", "Research Questions", "Staff Questions", "Candidates", "Settings", "Change to Judicial"]
            }
            else {
                self.items = ["Map", "Conference Schedule", "Bus Schedule", "Announcements", "Research Questions",  "Candidates",  "Change to Delegate", "Rounds"]
            }
        }
    }
    
    func pushViewController(viewController: UIViewController,
        animated: Bool, completion: Void -> Void) {
            
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            self.navigationController?.pushViewController(viewController, animated: animated)
            CATransaction.commit()
    }
}