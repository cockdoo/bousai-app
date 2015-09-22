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
        let x:Int = Int((lon / 180 + 1) * pow(2, z) / 2)
        let y:Int = Int(((-log(tan((45 + lat / 2) * M_PI / 180)) + M_PI) * pow(2, z) / (2 * M_PI)))
        print("x:\(x) y:\(y)")
        
        let xyArray = NSArray(array: [x, y])
        return xyArray
    }
    
    
    
    func sample0() {
        var URL:NSURL!
        URL = NSURL(string: "http://cyberjapandata.gsi.go.jp/xyz/bousai_app/h27/hinanjo/16/58170/25888.geojson")
        let jsonData :NSData! = NSData(contentsOfURL: URL)
        
        let json = (try? NSJSONSerialization.JSONObjectWithData(jsonData, options: [])) as? NSDictionary
            print(json)
        
    }
    
    func sample1() {
        var URL:NSURL!
        URL = NSURL(string: "http://cyberjapandata.gsi.go.jp/xyz/bousai_app/h27/hinanjo/16/58170/25888.geojson")
        let jsonData :NSData! = NSData(contentsOfURL: URL)
        
        let json = JSON(data: jsonData)
        print(json)
        if let title = json["features"][0]["type"].string {
            print(title)
        }
    }
    
}
