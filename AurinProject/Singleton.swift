//
//  Singleton.swift
//  AurinProject
//
//  Created by tiehuaz on 8/29/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//
import MapKit
class Singleton {
    class var sharedInstance: Singleton {
        struct Static {
            static var instance: Singleton?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = Singleton()
        }
        
        return Static.instance!
    }
    
    
    var totalDataMelb = Array<AnyObject>()
    var filterDataMelb = Array<AnyObject>()
    var dataSet:NSMutableDictionary = [:]
    var dataCollection = Array<String>()
    var flag : Int! = 0
    var selectedValue : String = ""
    var mapData = [String:[CLLocationCoordinate2D]]()
    var abstraction : String = ""
    var numDataInMel : Int = 0
    var benchMark = Array<Double>()
}