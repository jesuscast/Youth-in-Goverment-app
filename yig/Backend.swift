//
//  Backend.swift
//  yig
//
//  Created by Macbook on 10/18/15.
//  Copyright © 2015 Macbook. All rights reserved.
//

import Foundation
import Firebase

class Backend {
    
    enum Error {
        case ConnectionError
    }
    
    var options: [String : (FDataSnapshot -> Void)?] = [
        "announcements" : nil,
        "bills" : nil,
        "busSchedule" : nil,
        "candidates" : nil,
        "conferenceSchedule" : nil,
        "researchQuestions" : nil,
        "schoolList" : nil,
        "staffQuestions" : nil,
        "users" : nil,
        "annotations": nil,
        "listOfCommittees": nil
        
    ]
    
    var firebaseConnection = Firebase(url:"https://yig-bill-tracker.firebaseio.com")
    // Read data and react to changes
    
    func registerListeners() {
        for (key, value) in options {
            firebaseConnection.childByAppendingPath(key).observeEventType(.Value, withBlock: {
                snapshot in
                //print("\(snapshot.key) -> \(snapshot.value)")
                print("before receiving data")
                value?(snapshot)
            })
        }
    }
    var onError: (Error -> Void)? = nil
}