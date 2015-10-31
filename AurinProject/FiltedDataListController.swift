//
//  FiltedDataListController.swift
//  SidebarMenu
//
//  Created by tiehuaz on 8/26/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import MapKit

/** This class controlles the data listing interface showing the name of all datasets, it is also resposible to generate WFS query
*   according to user's selection for dataset, once user select one dataset, the dialConnection() function will be called and send
*   WFS query through HTTP request to GeoServer. After that, it will decode returned JSON data and store it into Singletion.swift.
*/

class FiltedDataListController: UITableViewController {
    

    var parentVC : MenuController!
    let user = Singleton.sharedInstance

    @IBAction func dis(sender: AnyObject) {

        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func trigger(sender: AnyObject) {
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(user.dataCollection.count) dataset in total"
        
      
 
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return user.dataCollection.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let data : String =  user.dataCollection[indexPath.row] 
        
        cell.textLabel?.text = data
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    
            user.selectedValue = user.dataCollection[indexPath.row]
            let tempArr : Array<String> = user.dataSet[user.selectedValue] as! Array<String>
            
            print(tempArr[0])
            
            
            var URL : String = "https://geoserver.aurin.org.au/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=\(tempArr[0])&bbox=144.553192,-38.225029,145.549774,-37.540119&maxFeatures=50&outputFormat=application/json"
            
            if(tempArr[0]=="nm:housingstress"){
                URL = "https://geoserver.aurin.org.au/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=\(tempArr[0])&bbox=144.489001,-38.053497,145.549774,-37.540119&maxFeatures=50&outputFormat=application/json"
                dialConnection(URL)
                user.flag = 0
                user.abstraction = tempArr[2] 
                self.performSegueWithIdentifier("toReveal", sender: self)
            }else if(tempArr[0]=="DSDBI:LGA_IA_2011_population_by_gender"){
                dialConnection(URL)
                user.flag = 1
                user.abstraction = tempArr[2]
                self.performSegueWithIdentifier("toReveal", sender: self)
            }else if(tempArr[0]=="vichealth:alcohol_purchased_last_7_days"){
                dialConnection(URL)
                user.flag = 2
                user.abstraction = tempArr[2]
                self.performSegueWithIdentifier("toReveal", sender: self)
            }
        
    }
    
    func dialConnection(url:String){
        HTTPGetJSON(url) { (dic:Dictionary<String, AnyObject>, error:String?) -> Void in
            if error != nil{
                print(error)
            }else {
                
                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                    self.user.totalDataMelb = dic["features"] as! Array
                    self.user.mapData = [String:[CLLocationCoordinate2D]]()
                    self.user.benchMark = Array<Double>()
                    for index in self.user.totalDataMelb{
                        
                        var property = index["properties"] as! Dictionary<String, AnyObject>
                        var geometry = index["geometry"] as! Dictionary<String, AnyObject>
                        var outCoordinates = geometry["coordinates"] as! [AnyObject]
                        var locationName : String = ""
                        var mapValue : Double = 0
                        var inCoordinates = outCoordinates[0] as! [AnyObject]
                        var innerCoordinates = inCoordinates[0] as! [AnyObject]
                        var coordinates = [CLLocationCoordinate2D]()
                        var totalLati : Double = 0
                        var totalLonti : Double = 0
                        for eachCoordinate in innerCoordinates{
                            var latitute = eachCoordinate[1] as! Double
                            var lontitute = eachCoordinate[0] as! Double
                            totalLati = totalLati+latitute
                            totalLonti = totalLonti+lontitute
                            coordinates.append(CLLocationCoordinate2DMake(latitute,lontitute))
                        }
                        let averageLati : Double = totalLati / Double(innerCoordinates.count)
                        let averageLonti : Double = totalLonti / Double(innerCoordinates.count)
                        if self.user.flag == 0{
                            locationName = property["sla_name"] as! String
                            var mapNum = property["housingstress_10"] as? Double
                            if mapNum != nil{
                                mapValue = mapNum!
                            }else{
                                mapValue = 24.5
                            }
                            self.user.mapData["\(locationName):\(averageLati):\(averageLonti):\(mapValue)"] = coordinates
                        }else if self.user.flag == 1{
                            locationName = property["lga_name"] as! String
                            mapValue = property["All_Person"] as! Double
                            self.user.mapData["\(locationName):\(averageLati):\(averageLonti):\(mapValue)"] = coordinates
                        }else if self.user.flag == 2{
                            locationName = property["lga_name06"] as! String
                            mapValue = property["numeric"] as! Double
                            let significance = property["significance"] as! String
                            self.user.mapData["\(locationName):\(averageLati):\(averageLonti):\(mapValue):\(significance)"] = coordinates
                            var bench = property["vic_ave"] as! Double
                            self.user.benchMark.append(bench)
                        }

                        
                    }
                    
                }
                
            }
            
        }
    }
    
    
    
    
}
