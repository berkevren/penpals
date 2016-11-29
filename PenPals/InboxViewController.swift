//
//  FirstViewController.swift
//  PenPals
//
//  Created by Berk Abbasoglu on 02/08/16.
//  Copyright © 2016 Berk Abbasoglu. All rights reserved.
//

import UIKit

class InboxViewController: UIViewController {
    
    @IBOutlet weak var messageContextTextView: UITextView!
    @IBOutlet weak var messageFromLabel: UILabel!
    @IBOutlet weak var messageDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AuthenticationService.sharedInstance.listMessages() {
            messageResult in
            
            if messageResult == true {
                
                self.messageFromLabel.text = AuthenticationService.sharedInstance.inbox?.messageList[0].firstName
                self.messageDateLabel.text = AuthenticationService.sharedInstance.inbox?.messageList[0].messageDate
                self.messageContextTextView.text = AuthenticationService.sharedInstance.inbox?.messageList[0].content
                
            }
            else {
                print("ABSOLUTELY NOTHING")
            }
        }
        
        
        
        //self.view.addBackground("istanbul")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

