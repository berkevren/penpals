//
//  FindFriendViewController.swift
//  PenPals
//
//  Created by Berk Abbasoglu on 08/08/16.
//  Copyright © 2016 Berk Abbasoglu. All rights reserved.
//

import Foundation
import UIKit

protocol FindFriendViewControllerDelegate {
    
    func setNation(nation:String)
    
}

class FindFriendViewController: UIViewController, UITextFieldDelegate, FindFriendViewControllerDelegate {
    
    @IBOutlet weak var selectNationTextField: UITextField!
    @IBOutlet weak var minAgeTextField: UITextField!
    @IBOutlet weak var maxAgeTextField: UITextField!
    @IBOutlet weak var genderField: UISegmentedControl!
    
    var selectedNation = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addBackground("newYorkCity")
        selectNationTextField.delegate = self
        minAgeTextField.delegate = self
        maxAgeTextField.delegate = self
        
        // prevent keyboard from showing
        let dummyView:UIView = UIView()
        selectNationTextField.inputView = dummyView
        
        //Looks for single or multiple taps to dismiss keyboard.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FindFriendViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: UI Text Field Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Actions
    
    @IBAction func nationValueChanged(sender: UITextField) {
        
        selectNationTextField.resignFirstResponder()
        selectNationTextField.userInteractionEnabled = false
        
    }
    
    @IBAction func findAFriendAction(sender: UIButton) {
        
        if selectNationTextField.text == "" {
            
            // alert controller
            let nationNotEnteredError:UIAlertController = UIAlertController(title: "Nation", message: "Please select a nation or click All", preferredStyle: UIAlertControllerStyle.Alert)
            
            // alert action
            let okButton:UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) {
                
                (action) in
                nationNotEnteredError.dismissViewControllerAnimated(true, completion: nil)
                
            }
            
            // add action
            nationNotEnteredError.addAction(okButton)
            // present view controller
            presentViewController(nationNotEnteredError, animated: true, completion: nil)
            
            
        }
        
        else if minAgeTextField.text == "" {
            
            // alert controller
            let minAgeNotEnteredError:UIAlertController = UIAlertController(title: "Age", message: "Please enter minimum age", preferredStyle: UIAlertControllerStyle.Alert)
            
            // alert action
            let okButton:UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) {
                
                (action) in
                minAgeNotEnteredError.dismissViewControllerAnimated(true, completion: nil)
                
            }
            
            // add action
            minAgeNotEnteredError.addAction(okButton)
            // present view controller
            presentViewController(minAgeNotEnteredError, animated: true, completion: nil)
            
            
        }
            
        else if maxAgeTextField.text == "" {
            
            // alert controller
            let maxAgeNotEnteredError:UIAlertController = UIAlertController(title: "Age", message: "Please enter maximum age", preferredStyle: UIAlertControllerStyle.Alert)
            
            // alert action
            let okButton:UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) {
                
                (action) in
                maxAgeNotEnteredError.dismissViewControllerAnimated(true, completion: nil)
                
            }
            
            // add action
            maxAgeNotEnteredError.addAction(okButton)
            // present view controller
            presentViewController(maxAgeNotEnteredError, animated: true, completion: nil)
            
        }
            
        else if Int(maxAgeTextField.text!) < Int(minAgeTextField.text!) {
            
            // alert controller
            let maxAgeError:UIAlertController = UIAlertController(title: "Age", message: "Max age cannot be lower than min age", preferredStyle: UIAlertControllerStyle.Alert)
            
            // alert action
            let okButton:UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) {
                
                (action) in
                maxAgeError.dismissViewControllerAnimated(true, completion: nil)
                
            }
            
            // add action
            maxAgeError.addAction(okButton)
            // present view controller
            presentViewController(maxAgeError, animated: true, completion: nil)
            
        }
            
        else if Int(minAgeTextField.text!) < 10 {
            
            // alert controller
            let tooLowAgeError:UIAlertController = UIAlertController(title: "Age", message: "Min age cannot be lower than 10", preferredStyle: UIAlertControllerStyle.Alert)
            
            // alert action
            let okButton:UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) {
                
                (action) in
                tooLowAgeError.dismissViewControllerAnimated(true, completion: nil)
                
            }
            
            // add action
            tooLowAgeError.addAction(okButton)
            // present view controller
            presentViewController(tooLowAgeError, animated: true, completion: nil)

            
        }
            
        else if Int(maxAgeTextField.text!) > 99 {
            
            // alert controller
            let tooHighAgeError:UIAlertController = UIAlertController(title: "Age", message: "Max age cannot be higher than 99", preferredStyle: UIAlertControllerStyle.Alert)
            
            // alert action
            let okButton:UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) {
                
                (action) in
                tooHighAgeError.dismissViewControllerAnimated(true, completion: nil)
                
            }
            
            // add action
            tooHighAgeError.addAction(okButton)
            // present view controller
            presentViewController(tooHighAgeError, animated: true, completion: nil)
            
        }
        
        // new shit
        else if let nation = self.selectNationTextField.text {
            
            let gender = genderField.selectedSegmentIndex == 1 ? "Female" : "Male"
            
            AuthenticationService.sharedInstance.match(nation, gender: gender) {
                (matchResult) in
                
                // check if matched
                if matchResult == true {
                    
                    // check to make sure not matched with self
                    if !(AuthenticationService.sharedInstance.matchedProfile!.equals((AuthenticationService.sharedInstance.current?.profile)!)) {
                    print("Matched with " + (AuthenticationService.sharedInstance.matchedProfile?.firstName)!)
                        
                        // try sending a message too!
                        
                        let message = Message()
                        message.content = "A warm hello to you!"
                        message.firstName = (AuthenticationService.sharedInstance.current?.profile.firstName)!
                        message.messageDate = "Right now"
                        message.messageStatus = "UNREAD"
                        message.receiverID = (AuthenticationService.sharedInstance.matchedProfile?.uID)!
                        message.senderID = (AuthenticationService.sharedInstance.current?.uID)!
                        
                        print("message sent to id " + message.receiverID)
                        print("message sent by id " + message.senderID)
                        
                        AuthenticationService.sharedInstance.sendMessage(message) {
                            messageSentResult in
                                
                            if messageSentResult == true {
                                print("message sent!")
                            }
                            
                        }
                        
                    }
                        
                    else {
                        
                        // alert controller
                        let noFriendsFoundError:UIAlertController = UIAlertController(title: "No Match", message: "No friends with your specifications found", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        // alert action
                        let okButton:UIAlertAction = UIAlertAction(title: "I'll change my criteria", style: .Cancel) {
                            
                            (action) in
                            noFriendsFoundError.dismissViewControllerAnimated(true, completion: nil)
                            
                        }
                        
                        // add action
                        noFriendsFoundError.addAction(okButton)
                        // present view controller
                        self.presentViewController(noFriendsFoundError, animated: true, completion: nil)
                        
                    }
                    
                }
                
                else {
                    
                    // alert controller
                    let noFriendsFoundError:UIAlertController = UIAlertController(title: "No Match", message: "No friends with your specifications found", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    // alert action
                    let okButton:UIAlertAction = UIAlertAction(title: "I'll change my criteria", style: .Cancel) {
                        
                        (action) in
                        noFriendsFoundError.dismissViewControllerAnimated(true, completion: nil)
                        
                    }
                    
                    // add action
                    noFriendsFoundError.addAction(okButton)
                    // present view controller
                    self.presentViewController(noFriendsFoundError, animated: true, completion: nil)
                    
                }
            }
        }
        
        else {
            
            // what the line says
            print("SHIT JUST GOT SERIOUS")
            
        }
    }
    
    @IBAction func selectNationAction(sender: UITextField) {
        
        let popupSelectNation = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("selectNation") as! SelectNationViewController
        popupSelectNation.findFriendViewControllerDelegate = self
        self.addChildViewController(popupSelectNation)
        popupSelectNation.view.frame = self.view.frame
        self.view.addSubview(popupSelectNation.view)
        popupSelectNation.didMoveToParentViewController(self)
        
    }
    @IBAction func selectAllNationsAction(sender: UIButton) {
        
        if selectNationTextField.text != "All" {
        
            selectNationTextField.text = "All"
            selectNationTextField.enabled = false
            
        }
            
        else {
            
            selectNationTextField.text = selectedNation
            selectNationTextField.enabled = true
            
         }
        
    }
    
    // MARK: protocol methods
    
    func setNation(nation:String) {
        
        selectNationTextField.text = nation
        selectedNation = nation
        selectNationTextField.endEditing(true)
        
    }
}

