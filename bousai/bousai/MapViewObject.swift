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
    
    func moveTo(lat:CLLocationDegrees, lon:CLLocationDegrees, zoom:Float) {
        var camera = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: zoom)
        self.camera = camera
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
