//
//  ResearchQuestionsViewController.swift
//  yig
//
//  Created by Macbook on 10/18/15.
//  Copyright © 2015 Macbook. All rights reserved.
//


import Foundation
import UIKit
import Firebase

extension String {
    init(sep:String, _ lines:String...){
        self = ""
        for (idx, item) in lines.enumerate() {
            self += "\(item)"
            if idx < lines.count-1 {
                self += sep
            }
        }
    }
    
    init(_ lines:String...){
        self = ""
        for (idx, item) in lines.enumerate() {
            self += "\(item)"
            if idx < lines.count-1 {
                self += "\n"
            }
        }
    }
}

class ResearchQuestionsViewController:UIViewController {
    var textField = UITextView()
    var sendButton = UIButton()
    var questions = TableStaffQuestionsViewController()
    var screenContainer = UIView()
    var backend = Backend()
    // var textFieldToBottomLayoutGuideConstraint: NSLayoutConstraint!
    var screenRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var screenWidth = CGFloat(0.0)
    
    var screenHeight = CGFloat(0.0)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the screen size variables
        screenRect = UIScreen.mainScreen().bounds
        screenWidth = screenRect.size.width
        screenHeight = screenRect.size.height
        // Set up the screenContainer.
        screenContainer.frame = CGRectMake(0, 65, screenWidth, screenHeight - 65)
        screenContainer.backgroundColor = UIColor.whiteColor()
        // Set up the textField to write responses
        textField.frame = CGRect(x: screenContainer.frame.size.width*0.025, y: (screenContainer.frame.size.height-100), width: screenContainer.frame.size.width*0.70, height: 70)
        textField.text = "Jesus was here"
        textField.layer.borderColor = UIColor.grayColor().CGColor
        textField.layer.borderWidth = 2.0
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        // Set up the send button
        // UIDevice.currentDevice().identifierForVendor!.UUIDString
        sendButton.frame = CGRect(x: screenContainer.frame.size.width*0.75, y: (screenContainer.frame.size.height-100), width: screenContainer.frame.size.width*0.20, height: 70)
        sendButton.layer.borderColor = UIColor.grayColor().CGColor
        sendButton.layer.cornerRadius = 5
        sendButton.layer.borderWidth = 2.0
        sendButton.setTitle("Submit", forState: .Normal)
        sendButton.layer.backgroundColor = UIColor(red:0.22, green:0.50, blue:0.87, alpha:1.0).CGColor
        sendButton.addTarget(self, action: "sendResearchQuestion:", forControlEvents: .TouchUpInside)
        self.screenContainer.addSubview(sendButton)
        // Set up the table view with the previous questions
        questions.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - 100 - 65)
        // Add the questions to the view.
        self.screenContainer.addSubview(questions.view)
        // Add the textField to the screen Container
        self.screenContainer.addSubview(textField)
        // Add the screen Container to the main view
        self.view.addSubview(self.screenContainer)
        // Set up all of the constrains
        //textField.autoConstrainAttribute(.Bottom, toAttribute: .Bottom, ofView: textField.superview!, withOffset: 0.0)
        
        // Set up observers for the keyboard.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name:UIKeyboardWillHideNotification, object: nil);
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    // Functions that writes the question to firebase
    func sendResearchQuestion(sender: UIButton) {
        let uniqueQuestionId = NSUUID().UUIDString
        let reference = backend.firebaseConnection.childByAppendingPath("researchQuestions/\(uniqueQuestionId)")
        let data = [
            "question" : "\(textField.text!)",
            "answer" : "",
            "sentTimestamp": "\(NSDate().timeIntervalSince1970)",
            "answeredTimestamp" : "",
            "source" : "\(UIDevice.currentDevice().identifierForVendor!.UUIDString)",
            "status" : "not answered"
        ]
        reference.setValue(data)
        // ------- questions.tableView.reloadData()
        // Create a callback that watches changes in this particular question
        // in case it is answered
        backend.firebaseConnection.childByAppendingPath("researchQuestions/\(uniqueQuestionId)").observeEventType(.Value, withBlock: {
            snapshot in
            //print("\(snapshot.key) -> \(snapshot.value)")
            print("before receiving data")
            // let value: (FDataSnapshot -> Void)? = self.backend.options["staffQuestions"]?
            self.backend.options["researchQuestions"]!!(snapshot)
        })
        
    }
    func keyboardWillShow(sender: NSNotification) {
        // Moves the screenContainer up
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            //self.textFieldToBottomLayoutGuideConstraint?.constant += keyboardSize.height
            self.screenContainer.frame.origin.y = self.screenContainer.frame.origin.y - keyboardSize.height
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        // Brings the screenContainer back into position
        if let _ = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.screenContainer.frame.origin.y = 65
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}