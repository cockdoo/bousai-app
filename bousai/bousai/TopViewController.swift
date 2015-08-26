//
//  TopViewController.swift
//  bousai
//
//  Created by wtnv009 on 2015/08/16.
//  Copyright (c) 2015年 TaigaSano. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {
    
    var lManager: LocationManagerObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        initializeLocationManager()
//        initializeDatabaseManager()
    }
    
    func initializeLocationManager() {
        lManager = LocationManagerObject()
        lManager.settingLocationManager()
    }
    
    func initializeDatabaseManager() {
        dbManager = DatabaseManagerObject()
        dbManager.makeInstanceOfFMDatabase()

        dbManager.createTable()
        dbManager.insertLocationData()
        var a = dbManager.getLocationData()
        println(a)
    }
    
    @IBAction func currentButtonTapped(sender: AnyObject) {
        toMainView()
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
