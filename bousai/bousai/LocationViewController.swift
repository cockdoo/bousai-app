//
//  LocationViewController.swift
//  bousai
//
//  Created by wtnv009 on 2015/08/16.
//  Copyright (c) 2015年 TaigaSano. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController,  CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager!
    
    @IBOutlet weak var startBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        startBtn.layer.cornerRadius = 5;
        settingLocationManager()
    }
    
    func settingLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    @IBAction func requestButtonTapped(sender: UIButton) {
        requetAuthorization()
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
            toSetHomeView()
            
            /*  何かしらの通知を出さないと  */
            
        case .AuthorizedAlways:
            statusStr = "AuthorizedAlways"
            toSetHomeView()
        case .AuthorizedWhenInUse:
            statusStr = "AuthorizedWhenInUse"
        }
        print(" CLAuthorizationStatus: \(statusStr)")
    }
    
    func toSetHomeView(){
        performSegueWithIdentifier("ToTopView", sender: nil);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ToTopView") {
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
