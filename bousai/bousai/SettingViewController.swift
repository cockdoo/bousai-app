//
//  SettingViewController.swift
//  bousai
//
//  Created by wtnv009 on 2015/09/01.
//  Copyright (c) 2015年 TaigaSano. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var switchBtn: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switchBtn.onTintColor = UIColor(red: 56/256, green: 204/255, blue: 182/255, alpha: 1)
        switchBtn.layer.cornerRadius = 16.0
        switchBtn.addTarget(self, action: Selector("switchChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        switchBtn.on = ud.boolForKey("chiriinMap")
    }
    
    func switchChanged(sender: UISwitch) {
        
        if sender.on {
            print("on")
            ud.setBool(true, forKey: "chiriinMap")
        }
        else {
            print("off")
            ud.setBool(false, forKey: "chiriinMap")
        }
        ud.synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnTouched(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
