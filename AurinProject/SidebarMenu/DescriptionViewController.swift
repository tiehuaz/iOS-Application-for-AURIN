//
//  DescriptionViewController.swift
//  AurinProject
//
//  Created by tiehuaz on 10/6/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {

    
    
    @IBOutlet weak var abstraction: UITextView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let user = Singleton.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        abstraction.text! = user.abstraction as! String
    }
    
    @IBAction func returnButton(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
