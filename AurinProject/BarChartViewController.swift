//
//  BarChartViewController.swift
//  AurinProject
//
//  Created by tiehuaz on 9/25/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import JBChart

class BarChartViewController: UIViewController , JBBarChartViewDelegate, JBBarChartViewDataSource{
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    @IBOutlet weak var showingLabel: UILabel!

    @IBOutlet weak var barChart: JBBarChartView!
    
    let user = Singleton.sharedInstance
    var chartDataName :[String] = []
    var chartData : [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        fileArray()
        
        
        showingLabel.text = ""
        
        view.backgroundColor = UIColor.darkGrayColor()
        
        barChart.backgroundColor = UIColor.darkGrayColor()
        barChart.delegate = self
        barChart.dataSource = self
        barChart.minimumValue = 0
        barChart.maximumValue = 40
        
        var footerView = UIView(frame: CGRectMake(0, 0, barChart.frame.width, 16))
        
        
        var header = UILabel(frame: CGRectMake(0, 20, barChart.frame.width, 50))
        header.textColor = UIColor.whiteColor()
        header.font = UIFont.systemFontOfSize(18)
        if(user.flag==0){
            header.text = "Income situation in different areas"
        }else if(user.flag==1){
            header.text = "Total Population in different areas"
        }else if(user.flag==2){
            header.text = "Alcohol Purchase in different areas"
        }
        
        header.textAlignment = NSTextAlignment.Center
        
        barChart.footerView = footerView
        barChart.headerView = header
        
        barChart.reloadData()
        
        barChart.setState(.Collapsed, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        barChart.reloadData()
        
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("showChart"), userInfo: nil, repeats: false)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        hideChart()
        
    }
    
    func hideChart(){
        self.barChart.setState(.Collapsed, animated: true)
    }
    func showChart(){
        barChart.setState(.Expanded, animated: true)
        
    }
    func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
        return UInt(chartData.count)
    }
    
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat {
        return CGFloat(chartData[Int(index)])
    }
    func barChartView(barChartView: JBBarChartView!, colorForBarViewAtIndex index: UInt) -> UIColor! {
        return (index % 2 == 0 ? UIColorFromHex(0x34b234) : UIColorFromHex(0x08bcef))
    }
    func barChartView(barChartView: JBBarChartView!, didSelectBarAtIndex index: UInt) {
        let data = chartData[Int(index)]
        let key = chartDataName[Int(index)]
        showingLabel.text = "\(key) : \(data)"
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    func fileArray(){
        if user.flag == 0{
            for each in user.totalDataMelb{
                let data : Dictionary<String,AnyObject> = each as! Dictionary
                let properties : Dictionary<String,AnyObject> = data["properties"] as! Dictionary
                
                chartDataName.append(properties["sla_name"] as! String)
                //            var income_low = properties["income_low"] as! Double
                //            var income_midd = properties["income_middle"] as! Double
                //            var income_hig = properties["income_high"] as! Double
                chartData.append(properties["income_high"] as! Double)
            }
        
        }else if user.flag == 1{
            for each in user.totalDataMelb{
                let data : Dictionary<String,AnyObject> = each as! Dictionary
                let properties : Dictionary<String,AnyObject> = data["properties"] as! Dictionary
                
                chartDataName.append(properties["lga_name"] as! String)
                
                chartData.append(properties["All_Person"] as! Double)
                
                
            }
        }else if user.flag == 2{
            for each in user.totalDataMelb{
                let data : Dictionary<String,AnyObject> = each as! Dictionary
                let properties : Dictionary<String,AnyObject> = data["properties"] as! Dictionary
                
                chartDataName.append(properties["lga_name06"] as! String)
                
                chartData.append(properties["numeric"] as! Double)
                
                
            }
        }
        
        
    }
    
    @IBAction func returnButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}