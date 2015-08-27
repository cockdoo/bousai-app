//
//  BousaiManagerObject.swift
//  bousai
//
//  Created by wtnv009 on 2015/08/27.
//  Copyright (c) 2015年 TaigaSano. All rights reserved.
//

import UIKit
import CoreLocation

class BousaiManagerObject: NSObject {
    
    func convertLatLonToTile(lat: CLLocationDegrees, lon: CLLocationDegrees, z: Double) -> NSArray {
        var x:Int = Int((lon / 180 + 1) * pow(2, z) / 2)
        var y:Int = Int(((-log(tan((45 + lat / 2) * M_PI / 180)) + M_PI) * pow(2, z) / (2 * M_PI)))
        println("x:\(x) y:\(y)")
        
        let xyArray = NSArray(array: [x, y])
        return xyArray
    }
    
    func getShelterInfo(lat: CLLocationDegrees, lon: CLLocationDegrees, zoom: Double) {
        
        var xyArray:NSArray = convertLatLonToTile(lat, lon: lon, z: zoom)
        
        println(xyArray[0])
        
        var URL:NSURL!
        URL = NSURL(string: "http://cyberjapandata.gsi.go.jp/xyz/bousai_app/h27/hinanjo/\(Int(zoom))/\(xyArray[0])/\(xyArray[1]).geojson")
        
        let jsonData :NSData! = NSData(contentsOfURL: URL)
        
        if (jsonData != nil) {
            let json = JSON(data: jsonData)
            println(json)
            
            for (index: String, subJson: JSON) in json["features"] {
                var coordinates = subJson["geometry"]["coordinates"]
                var lat = coordinates[1].doubleValue
                var lon = coordinates[0].doubleValue
                var name: String! = subJson["properties"]["name"].string
                
                mapView.setMarker(lat, lon: lon, name: name)
            }
        }
        
//        if let title = json["features"][0]["type"].string {
//            println(title)
//        }
    }
    
    func sample0() {
        var URL:NSURL!
        URL = NSURL(string: "http://cyberjapandata.gsi.go.jp/xyz/bousai_app/h27/hinanjo/16/58170/25888.geojson")
        let jsonData :NSData! = NSData(contentsOfURL: URL)
        
        var json = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: nil) as? NSDictionary
            println(json)
        
    }
    
    func sample1() {
        var URL:NSURL!
        URL = NSURL(string: "http://cyberjapandata.gsi.go.jp/xyz/bousai_app/h27/hinanjo/16/58170/25888.geojson")
        let jsonData :NSData! = NSData(contentsOfURL: URL)
        
        let json = JSON(data: jsonData)
        println(json)
        if let title = json["features"][0]["type"].string {
            println(title)
        }
    }
    
}
