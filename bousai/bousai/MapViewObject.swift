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
        
        self.frame = CGRectMake(0, 0, 320, 320)
    }
    
    func moveTo(lat: CLLocationDegrees, lon: CLLocationDegrees, zoom:Float) {
        var camera = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: zoom)
        self.camera = camera
    }
    
    func setOverLay() {
        var urls = { (x: UInt, y: UInt, zoom: UInt) -> NSURL in
            var url = "http://cyberjapandata.gsi.go.jp/xyz/std/\(zoom)/\(x)/\(y).png"
            return NSURL(string: url)!
        }
        var layer = GMSURLTileLayer(URLConstructor: urls)
        
        layer.zIndex = 100
        layer.opacity = 0.5
        layer.map = self
    }
    
    func setMarker(lat:Double, lon:Double, name: String) {
        var position = CLLocationCoordinate2DMake(lat, lon)
        var marker = GMSMarker(position: position)
        marker.title = name
        marker.map = self
    }
    
        
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
