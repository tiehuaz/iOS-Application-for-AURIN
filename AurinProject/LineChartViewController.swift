//
//  LineChartViewController.swift
//  AurinProject
//
//  Created by tiehuaz on 8/23/15.
//  Copyright (c) 2015 Tiehua Zhang. All rights reserved.
//
import UIKit
import JBChart



/** This controller is resposible to draw line chart, the data used in lines is previously stored in Singleton.swift
*   The title means what data is visualzied in here, each part of line is clickable, which will show the details of that
*   part at the footer label then.
*/

class LineChartViewController: UIViewController,JBLineChartViewDataSource,JBLineChartViewDelegate{
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var lineChart: JBLineChartView!
    @IBOutlet weak var informationView: UILabel!

    
    let user = Singleton.sharedInstance
    
    //the data for the first line
    var firstLineName : [String] = []
    var firstLineData : [Double] = []
    
    // data for second line
    var secondLineName : [String] = []
    var secondLineData : [Double] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        fileArray()
        
        informationView.text = ""
        informationView.font = UIFont.systemFontOfSize(16)
        informationView.textColor = UIColor.whiteColor()
        view.backgroundColor = UIColor.darkGrayColor()
        
        lineChart.backgroundColor = UIColor.darkGrayColor()
        lineChart.delegate = self
        lineChart.dataSource = self
        
        if user.flag == 0{
            lineChart.minimumValue = 5
            lineChart.maximumValue = 20
        }else if user.flag == 1{
            lineChart.minimumValue = 10000
            lineChart.maximumValue = 80000
        }else{
            lineChart.minimumValue = 0
            lineChart.maximumValue = 30
        }
        
        
        
        var footerView = UIView(frame: CGRectMake(0, 0, lineChart.frame.width, 51))
        
        var footer1 = UILabel(frame: CGRectMake(0, 0, lineChart.frame.width, 17))
        footer1.textColor = UIColor.whiteColor()
        footer1.font = UIFont.boldSystemFontOfSize(14)
        if (user.flag == 0){
            footer1.text = "white line represents houseing stress in 2006"
        }else if(user.flag == 1){
            footer1.text = "white line represents the population of male"
        }else if(user.flag == 2){
            footer1.font = UIFont.boldSystemFontOfSize(12)
            footer1.text = "white line represents high alcohol purchase indicator"
        }
        
        
        
        var footer2 = UILabel(frame: CGRectMake(0, 17, lineChart.frame.width, 17))
        footer2.textColor = UIColor.grayColor()
        footer2.font = UIFont.boldSystemFontOfSize(14)
        if (user.flag == 0){
            footer2.text = "grey line represents houseing stress in 2010"
        }else if(user.flag == 1){
            footer2.text = "grey line represents the population of female"
        }else if(user.flag == 2){
            footer2.font = UIFont.boldSystemFontOfSize(12)
            footer2.text = "grey line represents low alcohol purchase indicator"
        }

        footerView.addSubview(footer1)
        footerView.addSubview(footer2)
        
        if (user.flag == 2){
            var footer3 = UILabel(frame: CGRectMake(0, 34, lineChart.frame.width, 17))
            footer3.textColor = UIColor.redColor()
            footer3.font = UIFont.boldSystemFontOfSize(12)
            footer3.text = "red line represents benchmark indicator"
            footerView.addSubview(footer3)
        }
        
        var header = UILabel(frame: CGRectMake(0, 0, lineChart.frame.width, 50))
        header.textColor = UIColor.whiteColor()
        header.font = UIFont.boldSystemFontOfSize(14)
        if(user.flag==0){
            header.text = "Housing Stress Comparisions(different areas)"
        }else if(user.flag==1){
            header.text = "Male and Female Comparisions(different areas)"
        }else if(user.flag==2){
            header.text = "Alcohol Purchase Comparisions(different areas)"
        }
        header.textAlignment = NSTextAlignment.Center
        
        lineChart.footerView = footerView
        lineChart.headerView = header
        
        lineChart.reloadData()
        
        lineChart.setState(.Collapsed, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        lineChart.reloadData()
        
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("showChart"), userInfo: nil, repeats: false)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        hideChart()
        
    }
    
    func fileArray(){
        if user.flag == 0{
            for each in user.totalDataMelb{
                let data : Dictionary<String,AnyObject> = each as! Dictionary
                let properties : Dictionary<String,AnyObject> = data["properties"] as! Dictionary
                var name = properties["sla_name"] as! String
                firstLineName.append("2006 \(name)")
                
                if (properties["housingstress_06"] as? Double) != nil {
                    firstLineData.append(properties["housingstress_06"] as! Double)
                }else {
                    firstLineData.append(Double(16.0))
                }
                
                secondLineName.append("2010 \(name)")
                
                if (properties["housingstress_10"] as? Double) != nil {
                    secondLineData.append(properties["housingstress_10"] as! Double)
                }else {
                    secondLineData.append(Double(20.0))
                }
                
            }
            
        }else if user.flag == 1{
            for each in user.totalDataMelb{
                let data : Dictionary<String,AnyObject> = each as! Dictionary
                let properties : Dictionary<String,AnyObject> = data["properties"] as! Dictionary
                var name = properties["lga_name"] as! String
                firstLineName.append("Male in \(name)")
                firstLineData.append(properties["All_Male"] as! Double)
                secondLineName.append("Female in \(name)")
                secondLineData.append(properties["All_Female"] as! Double)
                
                
            }
        }else if user.flag == 2{
            for each in user.totalDataMelb{
                let data : Dictionary<String,AnyObject> = each as! Dictionary
                let properties : Dictionary<String,AnyObject> = data["properties"] as! Dictionary
                var name = properties["lga_name06"] as! String
                firstLineName.append("Low indicator in \(name)")
                firstLineData.append(properties["ci_low"] as! Double)
                secondLineName.append("High indicator in \(name)")
                secondLineData.append(properties["ci_high"] as! Double)
                
                
            }
        
        }

    }
    
    func hideChart(){
        self.lineChart.setState(.Collapsed, animated: true)
    }
    func showChart(){
        lineChart.setState(.Expanded, animated: true)
        
    }
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        if user.flag != 2{
            return 2
        }else {
            return 3
        }
        
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        if (lineIndex == 0 ){
            return UInt(secondLineData.count)
        }else if (lineIndex == 1){
            return UInt(firstLineData.count)
        }
        
        if user.flag == 2&&lineIndex == 2{
            return UInt(user.benchMark.count)
        }
        
        return 0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        if (lineIndex == 0 ){
            return CGFloat(secondLineData[Int(horizontalIndex)])
        }else if (lineIndex == 1 ){
            return CGFloat(firstLineData[Int(horizontalIndex)])
        }
        
        if user.flag == 2&&lineIndex == 2{
            return CGFloat(user.benchMark[Int(horizontalIndex)])
        }
        return 0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        if (lineIndex == 0 ){
            return UIColor.lightGrayColor()
        }else if (lineIndex == 1 ){
            return UIColor.whiteColor()
        }
        return UIColor.redColor()
    }
    
    func lineChartView(lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        if (lineIndex == 0 ){ return false}
        else if (lineIndex == 1 ){return false}
        return false
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor.grayColor()
    }
    
    func lineChartView(lineChartView: JBLineChartView!, smoothLineAtLineIndex lineIndex: UInt) -> Bool {
        if (lineIndex == 0 ){ return false}
        else if (lineIndex == 1 ){return false}
        return true
    }
    
    func lineChartView(lineChartView: JBLineChartView!, didSelectLineAtIndex lineIndex: UInt, horizontalIndex: UInt, touchPoint: CGPoint) {
        if (lineIndex == 0 ){
            let data = secondLineData[Int(horizontalIndex)]
            let key = secondLineName[Int(horizontalIndex)]
            informationView.text = "\(key) : \(data)"
        }else if (lineIndex == 1 ){
            let data = firstLineData[Int(horizontalIndex)]
            let key = firstLineName[Int(horizontalIndex)]
            informationView.text = "\(key) : \(data)"
        }else if (lineIndex == 2){
            let data = user.benchMark[Int(horizontalIndex)]
            informationView.text = "benchmark is : \(data)"
        }
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    @IBAction func returnButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}