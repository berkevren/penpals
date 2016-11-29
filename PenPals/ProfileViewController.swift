//
//  SecondViewController.swift
//  PenPals
//
//  Created by Berk Abbasoglu on 02/08/16.
//  Copyright © 2016 Berk Abbasoglu. All rights reserved.
//

import UIKit

extension UIImage{
    
    class func roundedRectImageFromImage(image:UIImage,imageSize:CGSize,cornerRadius:CGFloat)->UIImage{
        UIGraphicsBeginImageContextWithOptions(imageSize,false,0.0)
        let bounds=CGRect(origin: CGPointZero, size: imageSize)
        UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).addClip()
        image.drawInRect(bounds)
        let finalImage=UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage
    }
    
}

protocol ProfileViewControllerDelegate {
    
    func setNewProfilePic(newPic: UIImage)
    
}

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ProfileViewControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var whoIsLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var nationLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var onlineStatusLight: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    
    var profileImage:UIImage?// = UIImage(named: "margot")
    var edited = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.userInteractionEnabled = true
        descriptionText.delegate = self
        
        addProfileImage()
        /*/ set profile pic
        profilePic.image = UIImage.roundedRectImageFromImage(profileImage!, imageSize: profilePic.frame.size, cornerRadius: profilePic.frame.size.width / 2 ) */
        
        profilePic.userInteractionEnabled = true
        
        // set online status light
        let onlineDummyImage = UIImage(named: "onlineStatusOnline")
        onlineStatusLight.image = UIImage.roundedRectImageFromImage(onlineDummyImage!, imageSize: onlineStatusLight.frame.size, cornerRadius: onlineStatusLight.frame.size.width / 2)
        
        // set first name
        if let current = AuthenticationService.sharedInstance.current {
            
            // set labels with correct info
            firstNameLabel.text = current.profile.firstName
            nationLabel.text = current.profile.nation
            whoIsLabel.text = "Who is " + current.profile.firstName + "?"
            descriptionText.text = current.profile.description
            
            // calculate age
            // get current year
            let currentDate = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day , .Month , .Year], fromDate: currentDate)
            let currentYear =  components.year
            
            // get date of birth
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            var date = NSDate()
            date = dateFormatter.dateFromString(current.profile.birthdate)!
            let dateComponents = calendar.components([.Day , .Month , .Year], fromDate: date)
            
            // show age
            ageLabel.text = String(currentYear - dateComponents.year)

        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func changeProfilePicAction(sender: UITapGestureRecognizer) {
        
        // dismiss keybnoard just in case
        view.endEditing(true)
        
        let changeProfilePic = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("changeProfilePic") as! ChangeProfilePicViewController
        changeProfilePic.profileViewControllerDelegate = self
        
        if let dummyImage = profileImage {
            changeProfilePic.changeOldProfilePic(dummyImage)
        } else {
            changeProfilePic.changeOldProfilePic(UIImage(named: "margot")!)
        }
        //if let newDummyImage = profileImage {
          //  ChangeProfilePicViewController().changeOldProfilePic(newDummyImage)
        //}
        self.addChildViewController(changeProfilePic)
        changeProfilePic.view.frame = self.view.frame
        self.view.addSubview(changeProfilePic.view)
        changeProfilePic.didMoveToParentViewController(self)
        
    }
    
    @IBAction func editButtonAction(sender: UIButton) {
        
        if edited == false {
            descriptionShouldBeginEditing()
        }
        
        else {
            descriptionShouldEndEditing()
        }
        
    }
    
    
    @IBAction func tapScreenAction(sender: UITapGestureRecognizer) {
        
        if edited == true {
            descriptionShouldEndEditing()
        }
        
    }
    // MARK: UIImageControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        profilePic.image = UIImage.roundedRectImageFromImage(selectedImage, imageSize: profilePic.frame.size, cornerRadius: profilePic.frame.size.width / 2 )
        //profilePic.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func addProfileImage() {
        
        // check if pic is empty
        if let dummyImage = profileImage {
            profilePic.image = UIImage.roundedRectImageFromImage(dummyImage, imageSize: profilePic.frame.size, cornerRadius: profilePic.frame.size.width / 2 )
        }
        else {
        // set profile pic
        profilePic.image = UIImage.roundedRectImageFromImage(UIImage(named: "margot")!, imageSize: profilePic.frame.size, cornerRadius: profilePic.frame.size.width / 2 )
        }

        
    }
    
    // MARK: UI Text View Delegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        // when done
        if(text == "\n") {
            
            descriptionShouldEndEditing()
            return false
        }
        
        return textView.text.characters.count + (text.characters.count - range.length) <= 140
        
    }
    
    
    // MARK: Description update methods (2)
    func descriptionShouldBeginEditing() {
        
        whoIsLabel.text = "Enter max 140 characters"
        descriptionText.userInteractionEnabled = true
        descriptionText.becomeFirstResponder()
        descriptionText.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        editButton.setTitle("Done", forState: .Normal)
        edited = true
        
    }
    
    func descriptionShouldEndEditing() {
        
        AuthenticationService.sharedInstance.updateDescription(descriptionText.text) {
            (updateResult) in
            
            if updateResult == true {
                AuthenticationService.sharedInstance.current?.profile.description = self.descriptionText.text
            }
        }
        
        AuthenticationService.sharedInstance.current?.profile.description = descriptionText.text
        descriptionText.text = AuthenticationService.sharedInstance.current?.profile.description
        
        whoIsLabel.text = "Who is " + AuthenticationService.sharedInstance.current!.profile.firstName + "?"
        descriptionText.resignFirstResponder()
        view.endEditing(true)
        descriptionText.userInteractionEnabled = false
        descriptionText.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        
        editButton.setTitle("Edit", forState: .Normal)
        edited = false
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "logOut" {
            
            AuthenticationService.sharedInstance.logOut((AuthenticationService.sharedInstance.current?.email)!) {
                logOutResult in
                
                if logOutResult == true {
                    AuthenticationService.sharedInstance.current?.profile.onlineStatus = "OFFLINE"
                    print("you'll come back, crying")
                }
            }
            
        }
        
    }
    

    // MARK: protocol methods
    func setNewProfilePic(newPic: UIImage) {
        
        profileImage = newPic
        self.addProfileImage()
        
    }

}

