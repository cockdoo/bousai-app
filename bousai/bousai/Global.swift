//
//  Global.swift
//  bousai
//
//  Created by wtnv009 on 2015/08/26.
//  Copyright (c) 2015年 TaigaSano. All rights reserved.
//

import UIKit
import CoreLocation

var lManager: LocationManagerObject!
var dbManager: DatabaseManagerObject!
var bManager: BousaiManagerObject!

var mapView: MapViewObject!

var selectedLat: CLLocationDegrees!
var selectedLon: CLLocationDegrees!

var selectedName: String!
var selectedAddress: String!

var locationTableRows: Int!

var ud: NSUserDefaults!