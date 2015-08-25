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
    var rManager: RealmManagerObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        lManager = LocationManagerObject()
        lManager.settingLocationManager()
        
        setLocationButton()
        
        rManager = RealmManagerObject()
        rManager.test()
    }
    
    func setLocationButton() {
        
        for var num:Float = 0; num < 10; num++ {

        }
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
