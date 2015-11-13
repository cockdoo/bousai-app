//
//  LocationManagerObject.swift
//  bousai
//
//  Created by wtnv009 on 2015/08/16.
//  Copyright (c) 2015年 TaigaSano. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManagerObject: NSObject, CLLocationManagerDelegate {
   
    var currentLocation: CLLocation?
    var locationManager: CLLocationManager!
    var lat: CLLocationDegrees!
    var lon: CLLocationDegrees!
    
    func settingLocationManager() {
        lat = 0
        lon = 0
        
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
            if #available(iOS 8.0, *) {
                self.locationManager.requestAlwaysAuthorization()
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    // 位置情報のアクセス許可の状況が変わったときの処理
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        print("didChangeAuthorizationStatus");
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
        print(" CLAuthorizationStatus: \(statusStr)")
    }
    
    // 位置情報が取得できたときの処理
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0{
            currentLocation = (locations.last as? CLLocation?)!
            print("緯度:\(currentLocation?.coordinate.latitude) 経度:\(currentLocation?.coordinate.longitude)")
            
            lat = currentLocation?.coordinate.latitude
            lon = currentLocation?.coordinate.longitude
            
            if (ud.boolForKey("nonData") == true)  {
                print("初回だけすぐにデータを挿入")
                dbManager.insertLocationData(lat, lon: lon)
                
                ud.setBool(false, forKey: "nonData")
            }
        }
        //        manager.location.coordinate.latitude
    }
    
    // 位置情報取得に失敗した時に呼び出されるデリゲート.
    func locationManager(manager: CLLocationManager,didFailWithError error: NSError){
        print("locationManager error", terminator: "")
        
        locationManager.startUpdatingLocation()
    }
    
    var count: Int = 0
    
    func revGeocoding(lat: Double, lon: Double) {
        let location = CLLocation(latitude: lat, longitude: lon)
        var geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(location, completionHandler: CLGeocodeCompletionHandler)
        
        /*geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks:[AnyObject], error:NSError!) -> Void  in
            if (error == nil && placemarks.count > 0) { */
                
                /*let placemark: CLPlacemark! = placemarks[0] as? CLPlacemark*/
//                println("Country = \(placemark.country)")
//                println("Postal Code = \(placemark.postalCode)")
//                println("Administrative Area = \(placemark.administrativeArea)")
//                println("Sub Administrative Area = \(placemark.subAdministrativeArea)")
                /*print("Locality = \(placemark.locality)")*/
                /*print("Sub Locality = \(placemark.subLocality)")*/
//                println("Throughfare = \(placemark.thoroughfare)")
        
        let locality: String = ""
        let subLocality: String = ""
//                if (placemark.locality != nil && placemark.subLocality != nil) {
                    dbManager.insertToLivingAreaTable(lat, lon: lon, locality: locality, sublocality: subLocality)
//                }
        
                self.count = self.count + 1
                print(self.count)
                
                if (self.count == locationTableRows) {
                    print("全データ挿入完了！")
                    self.count = 0
                    dbManager.getDistinctPlaceList()
                }
                
            /*} else if (error == nil && placemarks.count == 0) {
                print("No results were returned.")
            } else if (error != nil) {
                print("An error occured = \(error.localizedDescription)")
            }
        })*/
    }
    
    var viewNum = 1;
    
    func getStreetViewURL(lat: CLLocationDegrees, lon: CLLocationDegrees, width: Int, height: Int) -> UIImage {
        
        let apiKey = "AIzaSyCslSIWQG0dnhS8BaeCIQyUxttCliecBdA"
        let heading = arc4random_uniform(360)
        let urlString = "http://maps.googleapis.com/maps/api/streetview?size=\(width*2)x\(height*2)&location=\(lat),\(lon)&heading=\(heading)&pitch=-0.76&sensor=true&fov=90&key=\(apiKey)"
        
        let url = NSURL(string: urlString)
        var err: NSError?
        
        print(url)
        let imageData : NSData = try! NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe)
        
        let img: UIImage! = UIImage(data: imageData)

        
//        let name: String! = "streetview0\(viewNum).jpg"
//        let img: UIImage! = UIImage(named: name)
//        viewNum++
        
        return img
    }
}

