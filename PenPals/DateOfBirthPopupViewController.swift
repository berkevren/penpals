//
//  DateOfBirthPopupViewController.swift
//  PenPals
//
//  Created by Berk Abbasoglu on 12/08/16.
//  Copyright © 2016 Berk Abbasoglu. All rights reserved.
//

import UIKit

class DateOfBirthPopupViewController: UIViewController {
    
    var registerViewControllerDelegate:RegisterViewControllerDelegate?

    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addBackground("sydney")
        self.view.backgroundColor = UIColor.whiteColor()

        datePicker.backgroundColor = UIColor(white:1, alpha: 0.9)
        datePicker.datePickerMode = UIDatePickerMode.Date
        
        self.showAnimate()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dateOfBirthDoneAction(sender: UIButton) {
        
        // get current year
        let currentDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: currentDate)
        let currentYear =  components.year
        
        // get date of birth
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy"
        
        let dateString = dateFormatter.stringFromDate(datePicker.date)
        let dateStringOnlyYear = dateString.substringFromIndex(dateString.startIndex.advancedBy(7))
        
        // make sure user is at least 10 years old
        if currentYear - Int(dateStringOnlyYear)! < 10 {
            
            // alert controller
            let tooYoungError:UIAlertController = UIAlertController(title: "Age", message: "You must be 10 years or older to register", preferredStyle: UIAlertControllerStyle.Alert)
            
            // alert action
            let okButton:UIAlertAction = UIAlertAction(title: "OK", style: .Cancel) {
                
                (action) in
                tooYoungError.dismissViewControllerAnimated(true, completion: nil)
                self.removeAnimate()
                
            }
            
            // add action
            tooYoungError.addAction(okButton)
            // present view controller
            presentViewController(tooYoungError, animated: true, completion: nil)
            
        }
        
        else {
            
            if let vcDelegate = registerViewControllerDelegate {
                vcDelegate.setDate(dateFormatter.stringFromDate(datePicker.date))
            
                // save also in different format
                dateFormatter.dateFormat = "dd/M/yyyy"
            
                vcDelegate.setDateWithDiffFormat(dateFormatter.stringFromDate(datePicker.date))
                
                }
            
            self.removeAnimate()
            
        }
    }
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
