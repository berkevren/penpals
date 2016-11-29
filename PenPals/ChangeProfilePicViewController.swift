//
//  changeProfilePicViewController.swift
//  PenPals
//
//  Created by Berk Abbasoglu on 23/08/16.
//  Copyright © 2016 Berk Abbasoglu. All rights reserved.
//

import UIKit

class ChangeProfilePicViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var profilePic: UIImageView!
    var oldProfilePic:UIImage?
    var newProfilePic:UIImage?
    
    var profileViewControllerDelegate:ProfileViewControllerDelegate?
    var picChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePic.image = oldProfilePic
        
        self.showAnimate()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Actions
    @IBAction func doneButtonAction(sender: UIButton) {
        
        if let vcDelegate = profileViewControllerDelegate {
            
            if picChanged == true {
                vcDelegate.setNewProfilePic(newProfilePic!)
            }
            else {
                vcDelegate.setNewProfilePic(oldProfilePic!)
            }
            
        }
        
        self.removeAnimate()
        
    }
    
    @IBAction func cancelButtonAction(sender: UIButton) {
    
        self.removeAnimate()
        
    }
    
    @IBAction func editPicAction(sender: UIButton) {
        
        // Create the alert controller
        let alertController = UIAlertController()
        
        // Create the actions
        let cameraAction = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
            
        }
        let cameraRollAction = UIAlertAction(title: "Choose Photo", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            // UIImagePickerController is a view controller that lets a user pick media from their photo library.
            let imagePickerController = UIImagePickerController()
            
            // Only allow photos to be picked, not taken.
            imagePickerController.sourceType = .PhotoLibrary
            
            // Make sure ViewController is notified when the user picks an image.
            imagePickerController.delegate = self
            
            self.presentViewController(imagePickerController, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            alertController.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        // Add the actions
        alertController.addAction(cameraAction)
        alertController.addAction(cameraRollAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)

        
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
        newProfilePic = selectedImage
        profilePic.image = newProfilePic
        
        picChanged = true
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func changeOldProfilePic(oldPic: UIImage) {
        
        oldProfilePic = oldPic
        
    }
    
    // MARK: Profile Pic Update Methdos // ToDo
    func profilePicShouldUpdate() {
        
        // image to binary
        let imageData = UIImagePNGRepresentation(profilePic.image!)
        // binary to base64
        let strBase64:String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
        // ToDO
        
    }
    
    // MARK: animate methods
    func showAnimate()
    {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }
    
    
    
}