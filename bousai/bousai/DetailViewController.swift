//
//  DetailViewController.swift
//  bousai
//
//  Created by wtnv009 on 2015/09/01.
//  Copyright (c) 2015年 TaigaSano. All rights reserved.
//

import UIKit
import GoogleMaps

class DetailViewController: UIViewController, GMSMapViewDelegate {
    
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var address: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setStreetView()
        
        placeName.text = selectedName
        placeName.adjustsFontSizeToFitWidth = true
        address.text = selectedAddress
        address.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func backBtnTouched(sender: AnyObject) {
        backToTopView()
    }
    
    func setStreetView() {
        let panoView = GMSPanoramaView(frame: CGRectMake(0, 98, 320, 470))
        panoView.moveNearCoordinate(CLLocationCoordinate2DMake(selectedLat, selectedLon), radius: 300)
        self.view.addSubview(panoView)
    }
    
    func backToTopView() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
