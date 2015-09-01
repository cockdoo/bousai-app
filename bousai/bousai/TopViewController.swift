//
//  TopViewController.swift
//  bousai
//
//  Created by wtnv009 on 2015/08/16.
//  Copyright (c) 2015年 TaigaSano. All rights reserved.
//

import UIKit
import CoreLocation

class TopViewController: UIViewController {
    
    var overView: UIView!
    var currentBtnTimer: NSTimer!
    var areaArrays: Array<Any>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        initializeLocationManager()
        initializeDatabaseManager()
        initializeBousaiManager()
        
        setLivingArea()
        setAreaBtns()
    }
    
    func initializeLocationManager() {
        lManager = LocationManagerObject()
        lManager.settingLocationManager()
    }
    
    func initializeDatabaseManager() {
        dbManager = DatabaseManagerObject()
        dbManager.makeInstanceOfFMDatabase()
        dbManager.createTable()
    }
    
    func initializeBousaiManager() {
        bManager = BousaiManagerObject()
//        bManager.sample0()
//        bManager.sample1()
    }
    
    func currentLocationButtonTapped() {
        if (lManager.lat != nil && lManager.lon != nil) {
            selectedLat = lManager.lat
            selectedLon = lManager.lon
            
            //テスト用
            selectedLat = 35.328800
            selectedLon = 139.538466
            
            selectedName = "現在地"
            toMainView()
        }
        else {
            //テスト用
            selectedLat = 35.338800
            selectedLon = 139.538466
            selectedName = "現在地"
            
            toMainView()
        }
    }
    
    func areaButtonTouched(sender: UIButton) {
        println(sender.tag)
        
        var areaArray: NSArray = areaArrays[sender.tag] as! NSArray
        var lat: Double = areaArray[0] as! Double
        var lon: Double = areaArray[1] as! Double
        var place: String = areaArray[2] as! String
        
        selectedLat = CLLocationDegrees(lat)
        selectedLon = CLLocationDegrees(lon)
        selectedName = place
        
        toMainView()
    }
    
    func setLivingArea() {
        dbManager.getDataCount("location")
        dbManager.truncateTable("livingarea");
        dbManager.getLocationData()
    }
    
    func setAreaBtns() {
        overView = UIView(frame: CGRectMake(0, 64, 320, 568-64))
        self.view.addSubview(overView)
        
        currentBtnTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("setCurrentView"), userInfo: nil, repeats: true)
        
        areaArrays =  dbManager.getDistinctArea()

        for var i = 0; i < areaArrays.count; i++ {
            var rect: CGRect!
            switch i {
                case 0:
                    rect = CGRectMake(10, 568-64-20-310, 145, 155)
                case 1:
                    rect = CGRectMake(10+145+10, 568-64-20-310, 145, 155)
                case 2:
                    rect = CGRectMake(10, 568-64-10-155, 145, 155)
                case 3:
                    rect = CGRectMake(10+145+10, 568-64-10-155, 145, 155)
                default:
                break
            }
            
            if (i < 4) {
                var areaArray: NSArray = areaArrays[i] as! NSArray
                var lat: Double = areaArray[0] as! Double
                var lon: Double = areaArray[1] as! Double
                var place: String = areaArray[2] as! String
                
                var areaBtn = UIButton(frame: rect)
                areaBtn.backgroundColor = UIColor(red: 56/256, green: 204/255, blue: 182/255, alpha: 1)
                areaBtn.layer.cornerRadius = 10
                areaBtn.clipsToBounds = true
                areaBtn.tag = i
                areaBtn.addTarget(self, action: Selector("areaButtonTouched:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                var bgView = UIView(frame: rect)
                bgView.layer.cornerRadius = 10
                bgView.backgroundColor = UIColor(red: 56/256, green: 204/255, blue: 182/255, alpha: 1)
                bgView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).CGColor
                bgView.layer.shadowOffset = CGSizeMake(1.0, 1.0)
                bgView.layer.shadowRadius = 0
                bgView.layer.shadowOpacity = 0.3
                bgView.layer.masksToBounds = false
                
                var label = UILabel(frame: CGRectMake(0, 128, 135, 28))
                label.text = place.componentsSeparatedByString("-")[1]
                label.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)
                label.textAlignment = NSTextAlignment.Right
                label.font = UIFont.systemFontOfSize(18)
                
                overView.addSubview(bgView)
                overView.addSubview(areaBtn)
                areaBtn.addSubview(label)
                
                var img = lManager.getStreetViewURL(lat, lon: lon, width: 145, height: 127)
                
                var imageView = UIImageView(image: img)
                imageView.frame = CGRectMake(0, 0, 145, 127)
                areaBtn.addSubview(imageView)
            }
        }
    }
    
    func setCurrentView(){
        if (lManager.lat != 0 && lManager.lon != 0) {
            println("よしきた")
            //現在地ボタンの作成
            var currentBtn = UIButton(frame: CGRectMake(10, 10, 300, 154))
            currentBtn.backgroundColor = UIColor(red: 56/256, green: 204/255, blue: 182/255, alpha: 1)
            currentBtn.layer.cornerRadius = 10
            currentBtn.clipsToBounds = true
            currentBtn.addTarget(self, action: Selector("currentLocationButtonTapped"), forControlEvents: UIControlEvents.TouchUpInside)
            
            var bgView = UIView(frame: CGRectMake(10, 10, 300, 154))
            bgView.layer.cornerRadius = 10
            bgView.backgroundColor = UIColor(red: 56/256, green: 204/255, blue: 182/255, alpha: 1)
            bgView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).CGColor
            bgView.layer.shadowOffset = CGSizeMake(1.0, 1.0)
            bgView.layer.shadowRadius = 0
            bgView.layer.shadowOpacity = 0.3
            bgView.layer.masksToBounds = false
            
            var label = UILabel(frame: CGRectMake(0, 127, 290, 28))
            label.text = "現在地"
            label.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)
            label.textAlignment = NSTextAlignment.Right
            label.font = UIFont.systemFontOfSize(18)
            
            overView.addSubview(bgView)
            overView.addSubview(currentBtn)
            currentBtn.addSubview(label)
            
            var img = lManager.getStreetViewURL(lManager.lat, lon: lManager.lon, width: 300, height: 126)
            var imageView = UIImageView(image: img)
            imageView.frame = CGRectMake(0, 0, 300, 126)
            currentBtn.addSubview(imageView)
            
            currentBtnTimer.invalidate()
        }
        else {
            println("今じゃない")
        }
    }
    
    func refreshAreaBtns() {
        overView.removeFromSuperview()
    }
    
    func toMainView() {
        performSegueWithIdentifier("ToMain", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ToMain") {
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
