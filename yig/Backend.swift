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
    enum Message {
        case BillChanged
        case SchoolChanged
    }
    enum Error {
        case ConnectionError
    }
    var firebaseConnection = Firebase(url:"https://yig-bill-tracker.firebaseio.com")
    // Read data and react to changes
    
    func registerListeners() {
    // Bill Updates
        firebaseConnection.childByAppendingPath("bills").observeEventType(.Value, withBlock: {
            snapshot in
            self.changeInBill(snapshot)
            print("\(snapshot.key) -> \(snapshot.value)")
        })
    // School Updates
        firebaseConnection.childByAppendingPath("schooList").observeEventType(.Value, withBlock: {
            snapshot in
            self.changeInSchool(snapshot)
            print("\(snapshot.key) -> \(snapshot.value)")
        })
    }
    
    func changeInBill(allBills: FDataSnapshot) {
        self.onMessage!(.BillChanged)
    }
    
    func changeInSchool(allSchools: FDataSnapshot) {
        self.onMessage!(.SchoolChanged)
    }
    var onMessage: (Message -> Void)? = nil
    var onError: (Error -> Void)? = nil
}