//
//  DataShowingAlcohol.swift
//  AurinProject
//
//  Created by tiehuaz on 10/14/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit

class DataShowingAlcohol: UIViewController {

    @IBOutlet weak var code: UILabel!
    var fakeCode: String!
    @IBOutlet weak var name: UILabel!
    var fakeName: String!
    @IBOutlet weak var num: UILabel!
    var fakeNum: String!
    @IBOutlet weak var low_num: UILabel!
    var fakeNumLow: String!
    @IBOutlet weak var high_num: UILabel!
    var fakeNumHigh: String!
    @IBOutlet weak var significance: UILabel!
    var fakeSig: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        code.text = fakeCode
        name.text = fakeName
        num.text = fakeNum
        low_num.text = fakeNumLow
        high_num.text = fakeNumHigh
        significance.text = fakeSig
        
    }
}
