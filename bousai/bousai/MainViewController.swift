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
    @IBOutlet weak var titleName: UILabel!
    
    @IBOutlet weak var shelterView: UIView!
    @IBOutlet weak var earthquakeView: UIView!
    @IBOutlet weak var tsunamiView: UIView!
    
    @IBOutlet weak var tsunamiDeep: UILabel!
    @IBOutlet weak var tsunamiHeight: UILabel!
    @IBOutlet weak var tsunamiTime: UILabel!
    
    @IBOutlet weak var earthquakeDegree: UILabel!
    
    
    var shelterArray: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeMap()
        
        println(selectedName)
        titleName.text = selectedName
        
        setShelter()
    }
    
    override func viewDidAppear(animated: Bool) {
        println("画面表示")
        setChiriinMap()
    }
    
    func initializeMap() {
        mapView = MapViewObject()
        mapView.initializeSetting()
        println(selectedLon)
        mapView.moveTo(selectedLat, lon: selectedLon, zoom: 14)
        self.view.addSubview(mapView)
    }
    
    func setChiriinMap() {
        if (ud.boolForKey("chiriinMap") == true) {
            mapView.setOverLay()
            println("地理院地図表示")
        }else {
            println("地理院地図表示しない")
//            mapView.clear()
        }
    }
    
/* 避難所 */
    
    @IBAction func shelterBtnTouched(sender: AnyObject) {
        setShelter()
    }

    func setShelter() {
        shelterView.hidden = false
        earthquakeView.hidden = true
        tsunamiView.hidden = true
        mapView.clear()
        shelterArray = NSMutableArray()
        
        setListBg()
        self.getShelterInfo(selectedLat, lon: selectedLon, zoom: 14)
        
        
        
        setChiriinMap()
    }
    
    func setListBg() {
        for var i = 0; i < 4; i++ {
            var listBg = UIView()
            let originY = CGFloat(12 + 42 * i)
            listBg.frame = CGRectMake(10.0, originY, 300.0, 34.0)
            listBg.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
            
            shelterView.addSubview(listBg)
        }
    }
    
    func getShelterInfo(lat: CLLocationDegrees, lon: CLLocationDegrees, zoom: Double) {
        
        //タイル座標に変換
        var xyArray:NSArray = bManager.convertLatLonToTile(lat, lon: lon, z: zoom)
        
        //JSONデータの取得
        var URL:NSURL!
        URL = NSURL(string: "http://cyberjapandata.gsi.go.jp/xyz/bousai_app/h27/hinanjo/\(Int(zoom))/\(xyArray[0])/\(xyArray[1]).geojson")
        
        println(URL)
        
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
                
                setMarker(lat, lon: lon, name: name)
                
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
            
            var num = 0
            for sortKey in keys {
                for (key, value) in distanceDictionary {
                    if sortKey == key.toInt() {
                        println("keyは\(key) valueは\(value)")
                        
                        var coordinates = json["features"][value.toInt()!]["geometry"]["coordinates"]
                        var lat = coordinates[1].doubleValue
                        var lon = coordinates[0].doubleValue
                        var name: String! = json["features"][value.toInt()!]["properties"]["name"].string
                        var address: String! = json["features"][value.toInt()!]["properties"]["address"].string
                        
                        println("\(name)")
                        
                        if (num < 4) {
                            shelterArray.addObject([lat, lon, name, address])
                            setShelterList(lat, lon: lon, name: name, index: num)
                        }
                        
                        num = num + 1
                    }
                }
            }
            setNumberMarker()
        }
    }
    
    func setMarker(lat:Double, lon:Double, name: String) {
        var position = CLLocationCoordinate2DMake(lat, lon)
        var marker = GMSMarker(position: position)
        marker.title = name
        
        var img: UIImage! = UIImage(named: "pin.png")
        let size = CGSize(width: 22, height: 30)
        UIGraphicsBeginImageContext(size)
        img.drawInRect(CGRectMake(0, 0, size.width, size.height))
        var resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        marker.icon = resizeImage
        
        marker.map = mapView
    }
    
    func setNumberMarker() {
        for var i = 0; i < shelterArray.count; i++ {
            var array: NSArray! = shelterArray[i] as! NSArray
            
            var position = CLLocationCoordinate2DMake(array[0] as! CLLocationDegrees, array[1] as! CLLocationDegrees)
            var marker = GMSMarker(position: position)
            marker.title = array[2] as! String
            marker.map = mapView
            marker.zIndex = 100-i
            
            var img: UIImage! = UIImage(named: "pin_\(i+1).png")
            let size = CGSize(width: 22, height: 30)
            UIGraphicsBeginImageContext(size)
            img.drawInRect(CGRectMake(0, 0, size.width, size.height))
            var resizeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            marker.icon = resizeImage
        }
    }
    
    func setShelterList(lat: Double, lon: Double, name: String, index: Int) {
        var listBtn = UIButton()
        let originY = CGFloat(12 + 42 * index)
        println(originY)
        listBtn.frame = CGRectMake(10.0, originY, 300.0, 34.0)
        listBtn.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        listBtn.addTarget(self, action: Selector("toDetailView:"), forControlEvents: UIControlEvents.TouchUpInside)
        listBtn.tag = index
        
        shelterView.addSubview(listBtn)
        
        var label = UILabel(frame: CGRectMake(10, 0, 300, 34))
        label.textAlignment = NSTextAlignment.Left
        label.text = "\(index + 1)　\(name)"
        label.font = UIFont.boldSystemFontOfSize(16)
        
        var img = UIImage(named: "syousai.png")
        var imageView = UIImageView(image: img)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.frame = CGRectMake(274, 8, 18, 18)
        
        
        listBtn.addSubview(label)
        listBtn.addSubview(imageView)
    }
    
    func toDetailView(sender: UIButton) {
        var tag = sender.tag
        
        var array: NSArray = shelterArray[tag] as! NSArray
        selectedLat = array[0] as! CLLocationDegrees
        selectedLon = array[1] as! CLLocationDegrees
        selectedName = array[2] as! String
        selectedAddress = array[3] as! String
        
        
        performSegueWithIdentifier("ToDetailView", sender: nil)
    }

/* 震度 */
    @IBAction func earthquakeBtnTouched(sender: AnyObject) {
        shelterView.hidden = true
        earthquakeView.hidden = false
        tsunamiView.hidden = true

        mapView.clear()
        setChiriinMap()
        
        mapView.setEarthquakeOverlay()
        
        
        getEarthQuakeDegree()
        setBigMap()
    }
    
    func getEarthQuakeDegree() {
        var URL:NSURL!
        URL = NSURL(string: "http://disaportal2.gsi.go.jp/hazardmap/bousaiapp/h27/api1.php?lon=\(selectedLon)&lat=\(selectedLat)&kind=shindo")
        
        let data: NSData! = NSData(contentsOfURL: URL)
        var string: String! = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
        
        if (string != nil) {
            earthquakeDegree.text = string
        }
    }
    
    func setBigMap() {
        var bigMap = GMSMapView(frame: CGRectMake(140, 27+11, 160, 135))
        bigMap.camera = GMSCameraPosition.cameraWithLatitude(selectedLat, longitude: selectedLon, zoom: 10)
        bigMap.settings.scrollGestures = false
        bigMap.settings.zoomGestures = false
        bigMap.settings.tiltGestures = false
        
        var urls = { (x: UInt, y: UInt, zoom: UInt) -> NSURL in
            var url = "http://cyberjapandata.gsi.go.jp/xyz/bousai_app/h27/shindo_r/\(zoom)/\(x)/\(y).png"
            return NSURL(string: url)!
        }
        var layer = GMSURLTileLayer(URLConstructor: urls)
        layer.map = bigMap
        earthquakeView.addSubview(bigMap)
    }

/* 津波 */
    @IBAction func tsunamiBtnTouched(sender: AnyObject) {
        shelterView.hidden = true
        earthquakeView.hidden = true
        tsunamiView.hidden = false

        mapView.clear()
        setChiriinMap()
        
        mapView.setTsunamiOverlay()
        
        getTsunamiDeep()
        getTsunamiHeight()
    }
    
    func getTsunamiDeep() {
        var URL:NSURL!
        URL = NSURL(string: "http://disaportal2.gsi.go.jp/hazardmap/bousaiapp/h27/api1.php?lon=\(selectedLon)&lat=\(selectedLat)&kind=tsunami1")
        
        let data: NSData! = NSData(contentsOfURL: URL)
        var string: String! = NSString(data: data, encoding: NSUTF8StringEncoding) as! String

        if (string != "") {
            tsunamiDeep.text = string
        }
        else {
            tsunamiDeep.text = ""
        }
    }
    
    func getTsunamiHeight() {
        
        var xyArray:NSArray = bManager.convertLatLonToTile(selectedLat, lon: selectedLon, z: 14)
        
        var URL:NSURL!
        URL = NSURL(string: "http://cyberjapandata.gsi.go.jp/xyz/bousai_app/h27/tsunami_height/14/\(xyArray[0])/\(xyArray[1]).geojson")
        
        let jsonData :NSData! = NSData(contentsOfURL: URL)
        
        if (jsonData != nil) {
            let json = JSON(data: jsonData)
            
            for (index: String, subJson: JSON) in json["features"] {
                var type = subJson["properties"]["type"]
                println(subJson)
                
                if (type == "南関東地震") {
                    tsunamiHeight.text = subJson["properties"]["height"].string
                    tsunamiTime.text = subJson["properties"]["time"].string
                }
            }
        }else {
            tsunamiHeight.text = ""
            tsunamiTime.text = ""
        }
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
