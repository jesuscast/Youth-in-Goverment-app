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
import Firebase

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

class ViewController: UIViewController {
    var nav: UINavigationController

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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



