//
//  MapViewObject.swift
//  bousai
//
//  Created by wtnv009 on 2015/08/26.
//  Copyright (c) 2015年 TaigaSano. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewObject: GMSMapView, GMSMapViewDelegate {
    
//    let sizeRate: CGFloat = 1.17
    
    func initializeSetting(width: CGFloat, height: CGFloat) {
        
        self.myLocationEnabled = true
        self.settings.myLocationButton = true
        self.settings.compassButton = true
        self.delegate = self
        
        self.frame = CGRectMake(0, 64, width, height)
    }
    
    func moveTo(lat: CLLocationDegrees, lon: CLLocationDegrees, zoom:Float) {
        let camera = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: zoom)
        self.camera = camera
    }
    
    func setOverLay() {
        let urls = { (x: UInt, y: UInt, zoom: UInt) -> NSURL in
            let url = "http://cyberjapandata.gsi.go.jp/xyz/std/\(zoom)/\(x)/\(y).png"
            return NSURL(string: url)!
        }
        let layer = GMSURLTileLayer(URLConstructor: urls)
        layer.zIndex = 100
        layer.opacity = 0.5
        layer.map = self
    }

    func setEarthquakeOverlay() {
        let urls = { (x: UInt, y: UInt, zoom: UInt) -> NSURL in
            let url = "http://cyberjapandata.gsi.go.jp/xyz/bousai_app/h27/shindo_r/\(zoom)/\(x)/\(y).png"
            return NSURL(string: url)!
        }
        let layer = GMSURLTileLayer(URLConstructor: urls)
        
        layer.zIndex = 100
        layer.opacity = 0.5
        layer.map = self
    }
    
    func setTsunamiOverlay() {
        let urls = { (x: UInt, y: UInt, zoom: UInt) -> NSURL in
            let url = "http://cyberjapandata.gsi.go.jp/xyz/bousai_app/h27/tsunami1_r/\(zoom)/\(x)/\(y).png"
            return NSURL(string: url)!
        }
        let layer = GMSURLTileLayer(URLConstructor: urls)
        
        layer.zIndex = 100
        layer.opacity = 0.5
        layer.map = self
    }
    
    func mapView(mapView: GMSMapView!, didChangeCameraPosition position: GMSCameraPosition!) {
        selectedLat = position.target.latitude
        selectedLon = position.target.longitude
    }
    
        
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
