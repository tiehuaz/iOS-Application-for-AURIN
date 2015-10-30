//
//  FilterViewController.swift
//  AurinProject
//
//  Created by tiehuaz on 8/29/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import SWXMLHash

class FilterViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate{
    
    var URL: String?
    
    let user = Singleton.sharedInstance
    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var organisationType: UITextField!
    @IBOutlet weak var dataType: UITextField!
    @IBOutlet weak var aggChoices: UITextField!
    
    var pickOption = ["Sydney","Melbourne","Brisbane","Perth","Canberra","Default"]
    var organisation = ["ABS","DSDBI","VicHealth","Default"]
    var data = ["Housing","Population","Alcohol","Health","Default"]
    var Aggregation = ["SA4","SA3","SA2","SA1","LGA","SLA","Default"]
    
    var myPickerForCity = UIPickerView()
    var myPickerForOrganisation = UIPickerView()
    var myPickerForData = UIPickerView()
    var myPickerForAggregation = UIPickerView()
    
    var toolBarCity = UIToolbar()
    var toolBarOrganisation = UIToolbar()
    var toolBarData = UIToolbar()
    var toolBarAggregation = UIToolbar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        HTTPGetXML("https://geoserver.aurin.org.au/ows?service=WFS&version=1.0.0&request=GetCapabilities"){
            (data: String, error: String?) -> Void in
            if error != nil{
                print(error)
            }else {
                    
                let xml = SWXMLHash.parse(data)
                    
                let choices = xml["WFS_Capabilities"]["FeatureTypeList"]["FeatureType"]
                
                
                for element in choices{
                    var key : String = element["Title"].element!.text!
                    var abstract =  element["Abstract"].element!.text
                    if abstract == nil{
                        abstract = "There is no description in this dataset."
                    }
                    var temp : String = abstract!
                    if key == "housingstress" {
                        var keyWordstoAdd = element["Keywords"].element!.text!
                        var keyWordsAdded = "\(keyWordstoAdd), ABS"
                        self.user.dataSet[key] = [element["Name"].element!.text!,keyWordsAdded,temp]
                    }else if key == "LGA_IA_2011_population_by_gender" || key == "LGA_IA_2006_population_by_gender"{
                        var keyWordstoAdd = element["Keywords"].element!.text!
                        var keyWordsAdded = "\(keyWordstoAdd), DSDBI, LGA"
                        self.user.dataSet[key] = [element["Name"].element!.text!,keyWordsAdded,temp]
                    }else if key == "alcohol_purchased_last_7_days"{
                        var keyWordstoAdd = element["Keywords"].element!.text!
                        var keyWordsAdded = "\(keyWordstoAdd), vichealth, LGA, health"
                        self.user.dataSet[key] = [element["Name"].element!.text!,keyWordsAdded,temp]
                    }else{
                        self.user.dataSet[key] = [element["Name"].element!.text!,element["Keywords"].element!.text!,temp]
                    }
                    
                }
           
            }
        }

    }
    
    
    

    override func viewWillAppear(animated: Bool) {
        
        toolBarCity.barStyle = UIBarStyle.Default
        toolBarCity.translucent = true
        toolBarOrganisation.barStyle = UIBarStyle.Default
        toolBarOrganisation.translucent = true
        toolBarData.barStyle = UIBarStyle.Default
        toolBarData.translucent = true
        toolBarAggregation.barStyle = UIBarStyle.Default
        toolBarAggregation.translucent = true
        
        myPickerForCity.delegate=self
        myPickerForOrganisation.delegate = self
        myPickerForData.delegate = self
        myPickerForAggregation.delegate = self
        toolBarCity.sizeToFit()
        toolBarOrganisation.sizeToFit()
        toolBarData.sizeToFit()
        toolBarAggregation.sizeToFit()
        myPickerForCity.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height/5, UIScreen.mainScreen().bounds.width, 100)
        myPickerForOrganisation.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height/5, UIScreen.mainScreen().bounds.width, 100)
        myPickerForData.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height/5, UIScreen.mainScreen().bounds.width, 100)
        myPickerForAggregation.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height/5, UIScreen.mainScreen().bounds.width, 100)
        
        
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Bordered, target: self, action: "donePressed1")
        var spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Bordered, target: self, action: "cancelPressed1")
        
        var doneButton1 = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Bordered, target: self, action: "donePressed2")
        var spaceButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var cancelButton1 = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Bordered, target: self, action: "cancelPressed2")
        
        var doneButton2 = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Bordered, target: self, action: "donePressed3")
        var spaceButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var cancelButton2 = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Bordered, target: self, action: "cancelPressed3")
        
        var doneButton3 = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Bordered, target: self, action: "donePressed4")
        var spaceButton3 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var cancelButton3 = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Bordered, target: self, action: "cancelPressed4")
        
        toolBarCity.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBarOrganisation.setItems([cancelButton1, spaceButton1, doneButton1], animated: false)
        toolBarData.setItems([cancelButton2, spaceButton2, doneButton2], animated: false)
        toolBarAggregation.setItems([cancelButton3, spaceButton3, doneButton3], animated: false)
        
        
        self.city.inputView = myPickerForCity;
        self.organisationType.inputView = myPickerForOrganisation;
        self.dataType.inputView = myPickerForData
        self.aggChoices.inputView = myPickerForAggregation
        city.inputAccessoryView = toolBarCity
        organisationType.inputAccessoryView = toolBarOrganisation
        dataType.inputAccessoryView = toolBarData
        aggChoices.inputAccessoryView = toolBarAggregation
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func filterCondition(sender: AnyObject) {
      
        self.user.dataCollection = []
        print("\(organisationType.text!.lowercaseString)+++\(dataType.text!.lowercaseString)+++\(aggChoices.text!.lowercaseString)")
        var orgTemp = organisationType.text!.lowercaseString
        var dataTemp = dataType.text!.lowercaseString
        var aggTemp = aggChoices.text!.lowercaseString
        if (orgTemp=="" || orgTemp=="default"){
            orgTemp=" "
        }
        if (dataTemp=="" || dataTemp=="default"){
            dataTemp=" "
        }
        
        if (aggTemp=="" || aggTemp=="default"){
            aggTemp=" "
        }

        
        for (key,value) in self.user.dataSet{
            var keyEle = key as! String
            var keyWords = value[1].lowercaseString as! String
            
            
            if (keyWords.containsString(orgTemp)&&keyWords.containsString(dataTemp)&&keyWords.containsString(aggTemp)){
                
                if keyEle == "housingstress"{
                    self.user.dataCollection.insert(keyEle, atIndex: 0)
                }else{
                    self.user.dataCollection.append(keyEle)
                }
            
            }
            
            
        }
        
    }
    

    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        
        return 1
        
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if(pickerView == myPickerForCity){
            return pickOption.count
        }else if (pickerView == myPickerForOrganisation){
            return organisation.count
        }else if(pickerView == myPickerForData){
            return data.count
        }else{
            return Aggregation.count
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == myPickerForCity){
            return pickOption[row]
        }else if(pickerView == myPickerForData){
            return data[row]
        }else if(pickerView == myPickerForAggregation){
            return Aggregation[row]
        }else{
            return organisation[row]
        }

    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(pickerView == myPickerForCity){
            city.text = "\(pickOption[pickerView.selectedRowInComponent(0)])"
        }else if(pickerView == myPickerForData){
            dataType.text = "\(data[pickerView.selectedRowInComponent(0)])"
        }else if(pickerView == myPickerForAggregation){
            aggChoices.text = "\(Aggregation[pickerView.selectedRowInComponent(0)])"
        }else{
            organisationType.text = "\(organisation[pickerView.selectedRowInComponent(0)])"
        }
        
        
    }
    
    func donePressed1() {
        city.resignFirstResponder()
    }
    
    func cancelPressed1() {
        city.text = ""
        city.resignFirstResponder()
    }
    
    func donePressed2() {
        organisationType.resignFirstResponder()
    }
    
    func cancelPressed2() {
        organisationType.text = ""
        organisationType.resignFirstResponder()
    }
    func donePressed3() {
        dataType.resignFirstResponder()
    }
    
    func cancelPressed3() {
        dataType.text = ""
        dataType.resignFirstResponder()
    }
    
    func donePressed4() {
        aggChoices.resignFirstResponder()
    }
    
    func cancelPressed4() {
        aggChoices.text = ""
        aggChoices.resignFirstResponder()
    }
    
    
}
