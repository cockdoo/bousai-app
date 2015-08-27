//
//  LocationManagerObject.swift
//  bousai
//
//  Created by wtnv009 on 2015/08/16.
//  Copyright (c) 2015年 TaigaSano. All rights reserved.
//

import UIKit
import CoreLocation

var selectedLat: CLLocationDegrees!
var selectedLon: CLLocationDegrees!

class LocationManagerObject: NSObject, CLLocationManagerDelegate {
   
    var currentLocation: CLLocation?
    var locationManager: CLLocationManager!
    var lat: CLLocationDegrees!
    var lon: CLLocationDegrees!
    
    func settingLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        // 取得精度の設定.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 取得頻度の設定.
        locationManager.distanceFilter = 100
    }
    
    func requetAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.NotDetermined) {
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
    // 位置情報のアクセス許可の状況が変わったときの処理
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        println("didChangeAuthorizationStatus");
        var statusStr = "";
        switch (status) {
        case .NotDetermined:
            statusStr = "NotDetermined"
        case .Restricted:
            statusStr = "Restricted"
        case .Denied:
            statusStr = "Denied"
        case .AuthorizedAlways:
            statusStr = "AuthorizedAlways"
            locationManager.startUpdatingLocation()
//            locationManager.startMonitoringSignificantLocationChanges()
        case .AuthorizedWhenInUse:
            statusStr = "AuthorizedWhenInUse"
//            locationManager.startUpdatingLocation()
        }
        println(" CLAuthorizationStatus: \(statusStr)")
    }
    
    // 位置情報が取得できたときの処理
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if locations.count > 0{
            currentLocation = locations.last as? CLLocation
            println("緯度:\(currentLocation?.coordinate.latitude) 経度:\(currentLocation?.coordinate.longitude)")
            
            lat = currentLocation?.coordinate.latitude
            lon = currentLocation?.coordinate.longitude
        }
        //        manager.location.coordinate.latitude
    }
    
    // 位置情報取得に失敗した時に呼び出されるデリゲート.
    func locationManager(manager: CLLocationManager!,didFailWithError error: NSError!){
        print("locationManager error")
    }
}

