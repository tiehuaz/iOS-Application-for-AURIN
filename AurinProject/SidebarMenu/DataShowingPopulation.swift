//
//  DataShowingBirth.swift
//  AurinProject
//
//  Created by tiehuaz on 9/27/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

class DataShowingPopulation: UIViewController {

    @IBOutlet weak var id: UILabel!
    var fakeID: String!
    @IBOutlet weak var name: UILabel!
    var fakeName: String!
    @IBOutlet weak var code: UILabel!
    var fakeCode: String!
    @IBOutlet weak var stateName: UILabel!
    var fakeState: String!
    @IBOutlet weak var male_num: UILabel!
    var fakeMale: String!
    @IBOutlet weak var female_num: UILabel!
    var fakeFemale: String!
    @IBOutlet weak var total_num: UILabel!
    var fakeTotal: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        id.text = fakeID
        name.text = fakeName
        code.text = fakeCode
        stateName.text = fakeState
        male_num.text = fakeMale
        female_num.text = fakeFemale
        total_num.text = fakeTotal
    
        
    }
}
