//
//  MenuController.swift
//  SidebarMenu
//
//  Created by tiehuaz on 8/29/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class MenuController: UITableViewController {

    @IBOutlet var viewTable: UITableView!
    @IBOutlet var bgImageView : UIImageView!
    @IBOutlet var dimmerView  : UIView!
    var testCount : Int! = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        viewTable.separatorStyle = .None

    }
    
    override func viewWillAppear(animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
