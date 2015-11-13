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
    
    var sizeRate: CGFloat = 1.17
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if self.view.frame.width == 320 {
            sizeRate = 1
        }
        
        initializeLocationManager()
        initializeDatabaseManager()
        initializeBousaiManager()

        
        setLivingArea()
        
        overView = UIView(frame: CGRectMake(0, 64 * sizeRate, 320 * sizeRate, (568-64) * sizeRate))
        self.view.addSubview(overView)
        
        setAreaBtnsBg()
        setAreaBtns()
    }
    
    @IBAction func refreshBtnTouched(sender: AnyObject) {
        overView.removeFromSuperview()
        
        overView = UIView(frame: CGRectMake(0, 64 * sizeRate, 320 * sizeRate, (568-64) * sizeRate))
        self.view.addSubview(overView)
        
        setLivingArea()
        setAreaBtnsBg()
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
//            selectedLat = 35.328800
//            selectedLon = 139.538466
            
            selectedName = "現在地"
            toMainView()
        }
        else {
            //テスト用
//            selectedLat = 35.338800
//            selectedLon = 139.538466
//            selectedName = "現在地"
//            
//            toMainView()
        }
    }
    
    func areaButtonTouched(sender: UIButton) {
        print(sender.tag)
        
        let areaArray: NSArray = areaArrays[sender.tag] as! NSArray
        let lat: Double = areaArray[0] as! Double
        let lon: Double = areaArray[1] as! Double
        let place: String = areaArray[2] as! String
        
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
    
    func setAreaBtnsBg() {
        let currentBtnBg = UIView(frame: CGRectMake(10 * sizeRate, 10 * sizeRate, 300 * sizeRate, 154 * sizeRate))
        currentBtnBg.layer.cornerRadius = 10
        currentBtnBg.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4).CGColor
        currentBtnBg.layer.borderWidth = 2;
        overView.addSubview(currentBtnBg)
        
        for var i = 0; i < 4; i++ {
            var rect: CGRect!
            switch i {
            case 0:
                rect = CGRectMake(10 * sizeRate, (568-64-20-310) * sizeRate, 145 * sizeRate, 155 * sizeRate)
            case 1:
                rect = CGRectMake((10+145+10) * sizeRate, (568-64-20-310) * sizeRate, 145 * sizeRate, 155 * sizeRate)
            case 2:
                rect = CGRectMake(10 * sizeRate, (568-64-10-155) * sizeRate, 145 * sizeRate, 155 * sizeRate)
            case 3:
                rect = CGRectMake((10+145+10) * sizeRate, (568-64-10-155) * sizeRate, 145 * sizeRate, 155 * sizeRate)
            default:
                break
            }
            
            let areaBtnBg = UIView(frame: rect)
            areaBtnBg.layer.cornerRadius = 10
            areaBtnBg.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4).CGColor
            areaBtnBg.layer.borderWidth = 2;
            overView.addSubview(areaBtnBg)
        }
    }
    
    func setAreaBtns() {
        
        currentBtnTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("setCurrentView"), userInfo: nil, repeats: true)
        
        areaArrays =  dbManager.getDistinctArea()
        
//        let area0:Array = [35.317931,139.499904,"鎌倉市-大船"] //自宅
//        let area1:Array = [35.353113,139.538310,"鎌倉市-津西"] //勤務地
//        let area2:Array = [35.318271,139.514939,"鎌倉市-鎌倉山"] //よく行くカフェ
//        let area3:Array = [35.318734,139.552864,"鎌倉市-小町"] //スポーツクラブ
//        areaArrays = [area0, area1, area2,area3]

        for var i = 0; i < areaArrays.count; i++ {
            var rect: CGRect!
            switch i {
            case 0:
                rect = CGRectMake(10 * sizeRate, (568-64-20-310) * sizeRate, 145 * sizeRate, 155 * sizeRate)
            case 1:
                rect = CGRectMake((10+145+10) * sizeRate, (568-64-20-310) * sizeRate, 145 * sizeRate, 155 * sizeRate)
            case 2:
                rect = CGRectMake(10 * sizeRate, (568-64-10-155) * sizeRate, 145 * sizeRate, 155 * sizeRate)
            case 3:
                rect = CGRectMake((10+145+10) * sizeRate, (568-64-10-155) * sizeRate, 145 * sizeRate, 155 * sizeRate)
            default:
                break
            }
            
            if (i < 4) {
                let areaArray: NSArray = areaArrays[i] as! NSArray
                let lat: Double = areaArray[0] as! Double
                let lon: Double = areaArray[1] as! Double
                let place: String = areaArray[2] as! String
                
                let areaBtn = UIButton(frame: rect)
                areaBtn.backgroundColor = UIColor(red: 56/256, green: 204/255, blue: 182/255, alpha: 1)
                areaBtn.layer.cornerRadius = 10
                areaBtn.clipsToBounds = true
                areaBtn.tag = i
                areaBtn.addTarget(self, action: Selector("areaButtonTouched:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                let bgView = UIView(frame: rect)
                bgView.layer.cornerRadius = 10
                bgView.backgroundColor = UIColor(red: 56/256, green: 204/255, blue: 182/255, alpha: 1)
                bgView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).CGColor
                bgView.layer.shadowOffset = CGSizeMake(1.0, 1.0)
                bgView.layer.shadowRadius = 0
                bgView.layer.shadowOpacity = 0.3
                bgView.layer.masksToBounds = false
                
                let label = UILabel(frame: CGRectMake(0, 127 * sizeRate, 135 * sizeRate, 28 * sizeRate))
                label.text = place.componentsSeparatedByString("-")[1]
                label.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)
                label.textAlignment = NSTextAlignment.Right
                label.font = UIFont(name: "Hiragino Kaku Gothic ProN", size: 18)
                
                overView.addSubview(bgView)
                overView.addSubview(areaBtn)
                areaBtn.addSubview(label)
                
                let img = lManager.getStreetViewURL(lat, lon: lon, width: 169, height: 148)
                
                let imageView = UIImageView(image: img)
                imageView.frame = CGRectMake(0, 0, 145 * sizeRate, 127 * sizeRate)
                areaBtn.addSubview(imageView)
                
                let imgName:String! = "\(i + 1)_1.png"
                let numberImg = UIImage(named: imgName)
                let numberImgView = UIImageView(image: numberImg)
                numberImgView.frame = CGRectMake(0, 0, 45 * sizeRate, 45 * sizeRate)
                areaBtn.addSubview(numberImgView)
            }
        }
    }
    
    func setCurrentView(){
//        if (lManager.lat != 0 && lManager.lon != 0) {

            //現在地ボタンの作成
            let currentBtn = UIButton(frame: CGRectMake(10 * sizeRate, 10 * sizeRate, 300 * sizeRate, 154 * sizeRate))
            currentBtn.backgroundColor = UIColor(red: 56/256, green: 204/255, blue: 182/255, alpha: 1)
            currentBtn.layer.cornerRadius = 10
            currentBtn.clipsToBounds = true
            currentBtn.addTarget(self, action: Selector("currentLocationButtonTapped"), forControlEvents: UIControlEvents.TouchUpInside)
            
            let bgView = UIView(frame: CGRectMake(10 * sizeRate, 10 * sizeRate, 300 * sizeRate, 154 * sizeRate))
            bgView.layer.cornerRadius = 10
            bgView.backgroundColor = UIColor(red: 56/256, green: 204/255, blue: 182/255, alpha: 1)
            bgView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).CGColor
            bgView.layer.shadowOffset = CGSizeMake(1.0, 1.0)
            bgView.layer.shadowRadius = 0
            bgView.layer.shadowOpacity = 0.3
            bgView.layer.masksToBounds = false
            
            let label = UILabel(frame: CGRectMake(0, 127 * sizeRate, 290 * sizeRate, 28 * sizeRate))
            label.text = "現在地"
            label.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)
            label.textAlignment = NSTextAlignment.Right
            label.font = UIFont(name: "Hiragino Kaku Gothic ProN", size: 18)
            
            let pinImg = UIImage(named: "pin_top.png")
            let pinImageView = UIImageView(image: pinImg)
            pinImageView.contentMode = UIViewContentMode.ScaleAspectFit
            pinImageView.frame = CGRectMake(214 * sizeRate, 131 * sizeRate, 20 * sizeRate, 20 * sizeRate)
            
            overView.addSubview(bgView)
            overView.addSubview(currentBtn)
            currentBtn.addSubview(label)
            currentBtn.addSubview(pinImageView)
            
            let img = lManager.getStreetViewURL(lManager.lat, lon: lManager.lon, width: 300, height: 126)
//            let img = UIImage(named: "streetview00.jpg")
        
            let imageView = UIImageView(image: img)
            imageView.frame = CGRectMake(0, 0, 300 * sizeRate, 126 * sizeRate)
            currentBtn.addSubview(imageView)
        
            currentBtnTimer.invalidate()
//        }
//        else {
//
//        }
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
