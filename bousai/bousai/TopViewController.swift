//
//  TopViewController.swift
//  bousai
//
//  Created by wtnv009 on 2015/08/16.
//  Copyright (c) 2015年 TaigaSano. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        initializeLocationManager()
        initializeDatabaseManager()
        initializeBousaiManager()
    }
    
    func initializeLocationManager() {
        lManager = LocationManagerObject()
        lManager.settingLocationManager()
    }
    
    func initializeDatabaseManager() {
        dbManager = DatabaseManagerObject()
        dbManager.makeInstanceOfFMDatabase()
//
        dbManager.createTable()
//        dbManager.insertLocationData()
        dbManager.getLocationData()
    }
    
    func initializeBousaiManager() {
        bManager = BousaiManagerObject()
//        bManager.sample0()
//        bManager.sample1()
        
    }
    
    @IBAction func currentLocationButtonTapped(sender: AnyObject) {
        if (lManager.lat != nil && lManager.lon != nil) {
            selectedLat = lManager.lat
            selectedLon = lManager.lon
            
            //テスト用
            selectedLat = 35.328800
            selectedLon = 139.538466
            
            toMainView()
        }
        else {
            //テスト用
            selectedLat = 35.338800
            selectedLon = 139.538466
            
            toMainView()
        }
    }
    
    func test() {
        
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
