//
//  RegisterViewController.swift
//  PenPals
//
//  Created by Berk Abbasoglu on 03/08/16.
//  Copyright © 2016 Berk Abbasoglu. All rights reserved.
//

import UIKit
import Alamofire

extension UIView {
    func addBackground(backgroundFile: String) {
        // screen width and height:
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: backgroundFile)
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
        
    }}

protocol RegisterViewControllerDelegate {

    func setDate(date:String)
    func setNation(nation:String)
    func setDateWithDiffFormat(date:String)
}

class RegisterViewController: UIViewController, UITextFieldDelegate, RegisterViewControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var genderField: UISegmentedControl!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nationTextField: UITextField!
    
    var dateDiffFormat:String = ""
    
    let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView  (activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    @IBAction func alreadyHaveAccountButton(sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addBackground("sydney")
        
        dateOfBirthTextField.delegate = self
        firstNameTextField.delegate = self
        confirmPasswordTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        nationTextField.delegate = self
        
        //nationTextField.userInteractionEnabled = true
        let dummyView:UIView = UIView()
        nationTextField.inputView = dummyView
        dateOfBirthTextField.inputView = dummyView
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UI Text Field Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Actions
    
    @IBAction func registerButton(sender: UIButton) {
        
        if emailTextField.text == "" || passwordTextField.text == "" || confirmPasswordTextField.text == "" || dateOfBirthTextField.text == "" || nationTextField.text == "" {
            
            // Create the alert controller
            let notAllFieldsEnteredAlert = UIAlertController(title: "Error", message: "Please fill all fields", preferredStyle: .Alert)
            
            // Create the actions
            let notAllFieldsEnteredAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                notAllFieldsEnteredAlert.dismissViewControllerAnimated(true, completion: nil)
                
            }
            
            // Add the actions
            notAllFieldsEnteredAlert.addAction(notAllFieldsEnteredAction)

            // present the view controller
            self.presentViewController(notAllFieldsEnteredAlert, animated: true, completion: nil)
            
            return
        }
        
        if passwordTextField.text != confirmPasswordTextField.text {
            
            // Create the alert controller
            let passwordsDontMatchAlert = UIAlertController(title: "Error", message: "The passwords are not the same", preferredStyle: .Alert)
            
            // Create the actions
            let passwordsDontMatchAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                passwordsDontMatchAlert.dismissViewControllerAnimated(true, completion: nil)
                
            }
            
            // Add the actions
            passwordsDontMatchAlert.addAction(passwordsDontMatchAction)
            
            // present the view controller
            self.presentViewController(passwordsDontMatchAlert, animated: true, completion: nil)
            
            return
            
        }
        
        let dateOfBirth = dateDiffFormat
        
        if let email = emailTextField.text,
            password = passwordTextField.text,
            firstName = firstNameTextField.text {
        
            let gender = genderField.selectedSegmentIndex == 1 ? "Female" : "Male"
            let nation = nationTextField.text
            
            let account = Account()
            account.email = email
            account.password = password
            account.profile.firstName = firstName
            account.profile.gender = gender
            account.profile.nation = nation!
            //account.profile.country = nation!
            account.profile.birthdate = dateOfBirth
            account.profile.description = "No description"
            
            
            
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
            
            
            AuthenticationService.sharedInstance.register(account){
                (registerResult) in
                
                if registerResult == true {
                    NSLog("register success")
                    
                    // register complete
                    // Create the alert controller
                    let alertController = UIAlertController(title: "Success", message: "Thank you. Registration complete.", preferredStyle: .Alert)
                    
                    // Create the actions
                    let toLoginAction = UIAlertAction(title: "To Login", style: UIAlertActionStyle.Default) {
                        UIAlertAction in
                        let toLogin = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("login") as! LoginViewController
                        toLogin.registerViewControllerDelegate = self
                        self.addChildViewController(toLogin)
                        toLogin.view.frame = self.view.frame
                        self.view.addSubview(toLogin.view)
                        toLogin.didMoveToParentViewController(self)
                        
                    }
                    
                    // Add the actions
                    alertController.addAction(toLoginAction)
                    
                    // hide activity indicator
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidesWhenStopped = true
                    
                    // enable user interaction
                    self.view.userInteractionEnabled = true
                    
                    // Present the controller
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }
                
            }
        }
        
    }
    
    func loginButtonClicked() {
        
        let loginViewController:AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("Login")
        self.showViewController(loginViewController as! UIViewController, sender: loginViewController)
        
    }
    
    @IBAction func selectNationAction(sender: UITextField) {
        
        let popupSelectNation = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("selectNation") as! SelectNationViewController
        popupSelectNation.registerViewControllerDelegate = self
        self.addChildViewController(popupSelectNation)
        popupSelectNation.view.frame = self.view.frame
        self.view.addSubview(popupSelectNation.view)
        popupSelectNation.didMoveToParentViewController(self)
        
    }
    
    @IBAction func nationChanged(sender: UITextField) {
        
        nationTextField.resignFirstResponder()
        nationTextField.userInteractionEnabled = false
        
    }
    
    @IBAction func dateOfBirthAction(sender: UITextField) {
        
        let popupDateOfBirth = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("dateOfBirthPopup") as! DateOfBirthPopupViewController
        popupDateOfBirth.registerViewControllerDelegate = self
        self.addChildViewController(popupDateOfBirth)
        popupDateOfBirth.view.frame = self.view.frame
        self.view.addSubview(popupDateOfBirth.view)
        popupDateOfBirth.didMoveToParentViewController(self)
        
    }
    
    // MARK: protocol methods
    func setDate(date: String) {
        dateOfBirthTextField.text = date
        dateOfBirthTextField.endEditing(true)
    }
    
    func setNation(nation: String) {
        nationTextField.text = nation
        nationTextField.endEditing(true)
    }
    
    func setDateWithDiffFormat(date: String) {
        
        dateDiffFormat = date
        
    }
    
    
}
