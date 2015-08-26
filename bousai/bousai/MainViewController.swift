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
    
    @IBOutlet weak var mapView: MapViewObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.initializeSetting()
        mapView.moveTo(-33.868, lon: 151.2086, zoom: 2)
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
