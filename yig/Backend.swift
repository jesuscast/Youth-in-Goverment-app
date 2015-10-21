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
    var firebaseConnection = Firebase(url:"https://yig-bill-tracker.firebaseio.com")
    // Read data and react to changes
    
    func registerListeners() {
    // Bill Updates
        firebaseConnection.ChildByAppendingPath("bills").observeEventType(.Value, withBlock: {
            snapshot in
            changeInBill(snapshot)
            println("\(snapshot.key) -> \(snapshot.value)")
        })
    // School Updates
        firebaseConnection.ChildByAppendingPath("schooList").observeEventType(.Value, withBlock: {
            snapshot in
            changeInSchool(snapshot)
            println("\(snapshot.key) -> \(snapshot.value)")
        })
    }
    
    func changeInBill(allBills: NSDictionary) {
    
    }
    
    func changeInSchool(allSchools: NSDictionary) {
    
    }
}