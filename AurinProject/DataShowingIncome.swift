//
//  DataShowing.swift
//  SidebarMenu
//
//  Created by tiehuaz on 9/23/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class DataShowingIncome: UIViewController {

    @IBOutlet weak var id: UILabel!
    
    var fakeID: String!
    
    @IBOutlet weak var code: UILabel!

    var fakeCode: String!

    @IBOutlet weak var name: UILabel!

    var fakeName: String!

    @IBOutlet weak var year06: UILabel!

    var fakeYear1: String!
    
    @IBOutlet weak var year10: UILabel!
    
    var fakeYear2: String!

    @IBOutlet weak var difference: UILabel!

    var differ: String!
    
    @IBOutlet weak var low_income: UILabel!

    var low: String!
    
    @IBOutlet weak var mid_income: UILabel!

    var mid: String!

    @IBOutlet weak var high_income: UILabel!
    
    var high: String!



    @IBAction func popView(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        id.text = fakeID
        code.text = fakeCode
        name.text = fakeName
        year06.text = fakeYear1
        year10.text = fakeYear2
        difference.text = differ
        low_income.text = low
        mid_income.text = mid
        high_income.text = high
        
    }
}
