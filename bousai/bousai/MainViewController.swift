//
//  MainViewController.swift
//  bousai
//
//  Created by wtnv009 on 2015/08/16.
//  Copyright (c) 2015年 TaigaSano. All rights reserved.
//

import UIKit
import GoogleMaps

class MainViewController: UIViewController {
    
    @IBOutlet weak var underView: UIView!
    var underContentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        underContentView = UIView()
        initializeMap()
    }
    
    func initializeMap() {
        mapView = MapViewObject()
        mapView.initializeSetting()
        mapView.moveTo(selectedLat, lon: selectedLon, zoom: 14)
        self.view.addSubview(mapView)
        //        mapView.setOverLay()
    }
    
    
/* 避難所 */
    
    @IBAction func shelterBtnTouched(sender: AnyObject) {
        underContentView.removeFromSuperview()
        setContentView()
        mapView.clear()
        setShelter()
    }
    
    func setContentView() {
        underContentView = UIView(frame: CGRectMake(0, 0, 320, 200))
        underContentView.backgroundColor = UIColor(red: 1, green: 1.0, blue: 0, alpha: 1)
        underView.addSubview(underContentView)
    }
    
    func setShelter() {
        self.getShelterInfo(selectedLat, lon: selectedLon, zoom: 14)
    }
    
    func getShelterInfo(lat: CLLocationDegrees, lon: CLLocationDegrees, zoom: Double) {
        
        //タイル座標に変換
        var xyArray:NSArray = bManager.convertLatLonToTile(lat, lon: lon, z: zoom)
        
        //JSONデータの取得
        var URL:NSURL!
        URL = NSURL(string: "http://cyberjapandata.gsi.go.jp/xyz/bousai_app/h27/hinanjo/\(Int(zoom))/\(xyArray[0])/\(xyArray[1]).geojson")
        
        
        var distanceDictionary: Dictionary = ["none": "none"]
        distanceDictionary.removeValueForKey("none")
        
        let jsonData :NSData! = NSData(contentsOfURL: URL)
        if (jsonData != nil) {
            let json = JSON(data: jsonData)
            
            println(json["features"])
            
            //取得データの数だけマーカーを設置
            for (index: String, subJson: JSON) in json["features"] {
                var coordinates = subJson["geometry"]["coordinates"]
                var lat = coordinates[1].doubleValue
                var lon = coordinates[0].doubleValue
                var name: String! = subJson["properties"]["name"].string
                
                mapView.setMarker(lat, lon: lon, name: name)
                
                //距離と番号のディクショナリーを作成
                let distance = CLLocation(latitude: selectedLat, longitude: selectedLon).distanceFromLocation(CLLocation(latitude: lat, longitude: lon))
                distanceDictionary["\(Int(distance))"] = index
                
            }
            
            var keys: [Int] = [99999999]
            for (key, val) in distanceDictionary {
                keys.append(key.toInt()!)
            }
            
            //距離の近い順に並び替え
            keys.sort { $0 < $1 }
            println(keys)
            
            //一番近い4箇所のリストを作成
            var num = 0
            for sortKey in keys {
                for (key, value) in distanceDictionary {
                    if sortKey == key.toInt() {
                        println("keyは\(key) valueは\(value)")
                        
                        var coordinates = json["features"][value.toInt()!]["geometry"]["coordinates"]
                        var lat = coordinates[1].doubleValue
                        var lon = coordinates[0].doubleValue
                        var name: String! = json["features"][value.toInt()!]["properties"]["name"].string
                        
                        println("\(name)")
                        
                        if (num < 4) {
                            setShelterList(lat, lon: lon, name: name, index: num)
                        }
                        num = num + 1
                    }
                }
            }
        }
    }
    
    func setShelterList(lat: Double, lon: Double, name: String, index: Int) {
        var listView = ShelterListView()
        
        let originY = CGFloat(35 * index)
        println(originY)
        listView.frame = CGRectMake(10.0, originY, 300.0, 30.0)
        underContentView.addSubview(listView)
    }

/* 震度 */
    @IBAction func earthquakeBtnTouched(sender: AnyObject) {
        underContentView.removeFromSuperview()
        setContentView()
        mapView.clear()
        mapView.setEarthquakeOverlay()
    }

/* 津波 */
    @IBAction func tsunamiBtnTouched(sender: AnyObject) {
        underContentView.removeFromSuperview()
        setContentView()
        mapView.clear()
        mapView.setTsunamiOverlay()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backBtnTouched(sender: AnyObject) {
        backToTopView()
    }
    
    func backToTopView() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
