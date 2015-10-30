//
//  MapViewController.swift
//  
//
//  Created by tiehuaz on 8/29/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    let user = Singleton.sharedInstance
    
    var measureNum :CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        print(user.mapData.count)
        
    }

    override func viewWillAppear(animated: Bool) {
        addPolygonToMap()
        openMapForPlace()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if (overlay is MKPolygon) {
            var overlayPathView = MKPolygonRenderer(overlay: overlay)
            overlayPathView.fillColor = UIColor.redColor().colorWithAlphaComponent(measureNum)
            overlayPathView.strokeColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
            overlayPathView.lineWidth = 5
            return overlayPathView
        } else if (overlay is MKPolyline) {
            
            var overlayPathView = MKPolylineRenderer(overlay: overlay)
            overlayPathView.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.7)
            overlayPathView.lineWidth = 1
            
            return overlayPathView
        }
        
        return nil
    }
    func addPolygonToMap() {
        
        for (suburbName,polygon) in user.mapData{
            var stringArr = suburbName.componentsSeparatedByString(":")
            var points = polygon
            var range = Double(stringArr[3])!
            
            if user.flag == 0{
                if range<10{
                    measureNum = 0.2
                }else if(range>=10&&range<15){
                    measureNum = 0.4
                }else if(range>=15&&range<20){
                    measureNum = 0.6
                }else{
                    measureNum = 0.8
                }
            }else if user.flag == 1{
                if range<80000{
                    measureNum = 0.2
                }else if(range>=80000&&range<120000){
                    measureNum = 0.4
                }else if(range>=120000&&range<160000){
                    measureNum = 0.6
                }else{
                    measureNum = 0.8
                }
            }else if user.flag == 2{
                if range<30{
                    measureNum = 0.2
                }else if(range>=30&&range<35){
                    measureNum = 0.4
                }else if(range>=35&&range<40){
                    measureNum = 0.6
                }else{
                    measureNum = 0.8
                }
            }
            

            var polygon = MKPolygon(coordinates: &points, count: points.count)
            self.mapView.addOverlay(polygon)
            
            var lati : Double = Double(stringArr[1])!
            var lonti : Double = Double(stringArr[2])!
            
            var pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(lati,lonti)
            var objectAnnotation = MKPointAnnotation()
            objectAnnotation.coordinate = pinLocation
            objectAnnotation.title = stringArr[0] as! String
            if user.flag == 0{
                objectAnnotation.subtitle = "housing stress: \(range)"
            }else if user.flag == 1{
                objectAnnotation.subtitle = "population: \(range)"
            }else if user.flag == 2{
                objectAnnotation.subtitle = "numeric: \(range), Severity: \(stringArr[4])"
            }
            
            self.mapView.addAnnotation(objectAnnotation)
        }
//        var polygon = MKPolygon(coordinates: &p, count: p.count)
//        self.mapView.addOverlay(polygon)
        
        
        //        }
        
        //        self.isDrawingPolygon = false
        //        self.drawPolygonButton.setTitle("Draw", forState: .Normal)
        //        self.canvasView.image = nil
        //        self.canvasView.removeFromSuperview()
    }
    func openMapForPlace() {
        let span = MKCoordinateSpanMake(1, 1)
        let location = CLLocationCoordinate2D(
            latitude: (-37.796286-37.804424-37.852993)/3,
            longitude: (144.927181+145.027181+144.927181)/3
        )
        
        let region = MKCoordinateRegion(center: location, span: span)
        //        let regionDistance: CLLocationDistance = 1000000
        mapView.setRegion(region, animated: true)
     
        
    }
    
    @IBAction func returnButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
   

}
