//
//  LoginViewController.swift
//  PenPals
//
//  Created by Berk Abbasoglu on 02/08/16.
//  Copyright © 2016 Berk Abbasoglu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var registerViewControllerDelegate:RegisterViewControllerDelegate?
    let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView  (activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addBackground("paris")
        
        txtUsername.text = "margot@email.com"
        txtPassword.text = "crazy"
        
        //Looks for single or multiple taps to dismiss keyboard.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: Actions
    
    @IBAction func forgotPasswordAction(sender: UIButton) {
        
        // alert controller
        let forgotPasswordView:UIAlertController = UIAlertController(title: "Forgot Password", message: "You must remember that password!", preferredStyle: UIAlertControllerStyle.Alert)
        
        // alert action
        let okButton:UIAlertAction = UIAlertAction(title: "I'll think harder!", style: .Cancel) {
            
            (action) in
            forgotPasswordView.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        // add action
        forgotPasswordView.addAction(okButton)
        // present view controller
        presentViewController(forgotPasswordView, animated: true, completion: nil)
        
    }

    @IBAction func login() {
        
        // disable user interaction
        self.view.userInteractionEnabled = false
        
        // show activity indicator
        activityIndicator.color = UIColor.magentaColor()
        activityIndicator.frame = CGRectMake(0.0, 0.0, 10.0, 10.0)
        activityIndicator.center = self.view.center
        activityIndicator.transform = CGAffineTransformMakeScale(4, 4)
        self.view.addSubview(activityIndicator)
        activityIndicator.bringSubviewToFront(self.view)
        activityIndicator.startAnimating()
        
        // this helps
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
        
            // make sure there is an email
            if self.txtUsername.text == "" {
                
                // alert controller
                let noEmail:UIAlertController = UIAlertController(title: "Error", message: "Please enter email", preferredStyle: UIAlertControllerStyle.Alert)
                
                // alert action
                let okButton:UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) {
                    
                    (action) in
                    noEmail.dismissViewControllerAnimated(true, completion: nil)
                    
                }
                
                // add action
                noEmail.addAction(okButton)
                // present view controller
                self.presentViewController(noEmail, animated: true, completion: nil)
                
            }
                
            // make sure there is a password
            else if self.txtPassword.text == "" {
                
                // alert controller
                let noPassword:UIAlertController = UIAlertController(title: "Error", message: "Please enter password", preferredStyle: UIAlertControllerStyle.Alert)
                
                // alert action
                let okButton:UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) {
                    
                    (action) in
                    noPassword.dismissViewControllerAnimated(true, completion: nil)
                    
                }
                
                // add action
                noPassword.addAction(okButton)
                // present view controller
                self.presentViewController(noPassword, animated: true, completion: nil)
                
                
            }
                
            // check account credentials
            else if let username = self.txtUsername.text, password = self.txtPassword.text {
                AuthenticationService.sharedInstance.login(username, password: password) {
                    (loginResult) in
                    
                    // check if login was successful
                    if loginResult == true {
                        
                        // switch VC
                        let findFriendVC:AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("tabView")
                        self.showViewController(findFriendVC as! UIViewController, sender: self)
                        
                        
                    } else {
                        
                        // alert controller
                        let invalidCreds:UIAlertController = UIAlertController(title: "Error", message: "Invalid username or password", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        // alert action
                        let okButton:UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) {
                            
                            (action) in
                            invalidCreds.dismissViewControllerAnimated(true, completion: nil)
                            
                        }
                        
                        // add action
                        invalidCreds.addAction(okButton)
                        // present view controller
                        self.presentViewController(invalidCreds, animated: true, completion: nil)
                        
                    }
                }
            }
                
            else {
                
                // alert controller
                let iHaveNoIdea:UIAlertController = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: UIAlertControllerStyle.Alert)
                
                // alert action
                let okButton:UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) {
                    
                    (action) in
                    iHaveNoIdea.dismissViewControllerAnimated(true, completion: nil)
                    
                }
                
                // add action
                iHaveNoIdea.addAction(okButton)
                // present view controller
                self.presentViewController(iHaveNoIdea, animated: true, completion: nil)
                
            }
        
            // this helps too
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // hide activity indicator
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
            })
        });
        
        // enable user interaction
        self.view.userInteractionEnabled = true
       
    }
    

}
