//
//  MapViewObject.swift
//  bousai
//
//  Created by wtnv009 on 2015/08/26.
//  Copyright (c) 2015年 TaigaSano. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewObject: GMSMapView {
    
    func initializeSetting() {
        self.myLocationEnabled = true
        self.settings.myLocationButton = true
        self.settings.compassButton = true
    }
    
    func moveTo(lat: CLLocationDegrees, lon: CLLocationDegrees, zoom:Float) {
        var camera = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: zoom)
        self.camera = camera
    }
    
    func overLay() {
        var urls = { (x: UInt, y: UInt, zoom: UInt) -> NSURL in
            var url = "http://cyberjapandata.gsi.go.jp/xyz/std/\(zoom)/\(x)/\(y).png"
            return NSURL(string: url)!
        }
        
        var layer = GMSURLTileLayer(URLConstructor: urls)
        
        layer.zIndex = 100
        layer.opacity = 0.5
        layer.map = self
    }
    

    func convertLatLonToTile(lat: CLLocationDegrees, lon: CLLocationDegrees, z: Double) {
        var x:Int = Int((lon / 180 + 1) * pow(2, z) / 2)
        var y:Int = Int(((-log(tan((45 + lat / 2) * M_PI / 180)) + M_PI) * pow(2, z) / (2 * M_PI)))
        println("x:\(x) y\(y)")
        
        let xyArray = NSArray()
    }

    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
