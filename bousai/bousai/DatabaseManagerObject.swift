//
//  DatabaseManagerObject.swift
//  bousai
//
//  Created by wtnv009 on 2015/08/26.
//  Copyright (c) 2015年 TaigaSano. All rights reserved.
//

import UIKit

class DatabaseManagerObject: NSObject {
    var db: FMDatabase!
    
    func makeInstanceOfFMDatabase() {
        // get path of /Documents
        let paths = NSSearchPathForDirectoriesInDomains( .DocumentDirectory, .UserDomainMask, true)
        
        // generate to /Documents/swift2objectc.db
        let _path = paths[0].stringByAppendingPathComponent("swift2objectc.db")
        
        // make instance of FMDatabase
        db = FMDatabase(path: _path)
    }
    
    func createTable() {
        db.open()
        var sql = "CREATE TABLE IF NOT EXISTS location (id INTEGER PRIMARY KEY, lat char(10), lon char(10));"
        let ret = db.executeUpdate(sql, withArgumentsInArray: nil)
        db.close()
        
        if ret {
            println("テーブルの作成に成功")
        }
    }
    
    func insertLocationData(lat: Double, lon: Double) {
        println(lat)
        db.open()
        var sql = "INSERT INTO location (lat, lon) VALUES (?, ?);"
        db.executeUpdate(sql, withArgumentsInArray: [lat, lon])
//        db.executeUpdate(sql, withArgumentsInArray: [36.342141, 132.875689])
        db.close()
    }
    
    func getLocationData(){
        db.open()
        var sql = "SELECT id, lat, lon FROM location ORDER BY id;"
        let results = db.executeQuery(sql, withArgumentsInArray: nil)
        
        while results.next() {
            let id = results.intForColumn("id")
            let lat = results.doubleForColumn("lat")
            let lon = results.doubleForColumn("lon")
            // print data
            println("lat:\(lat) lon:\(lon)")
        }
        db.close()
    }
    
    func sample() {
        // database open and create database
        db.open()
        
        //create table
        var sql = "CREATE TABLE IF NOT EXISTS sample (user_id INTEGER PRIMARY KEY, user_name TEXT);"
        let ret = db.executeUpdate(sql, withArgumentsInArray: nil)
        
        // insert data
        sql = "INSERT INTO sample (user_name) VALUES (?);"
        db.executeUpdate(sql, withArgumentsInArray: ["bb"])
        
        // read data
        sql = "SELECT user_id, user_name FROM sample ORDER BY user_id;"
        let results = db.executeQuery(sql, withArgumentsInArray: nil)
        
        while results.next() {
            let user_id = results.intForColumn("user_id")
            let user_name = results.stringForColumnIndex(1)
            // print data
            println("user_id = \(user_id), user_name = \(user_name)")
        }
        
        // database close
        db.close()
    }
    
    func sample2() {
        // /Documentsまでのパスを取得
        let paths = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory,
            .UserDomainMask, true)
        // <Application>/Documents/sample.db というパスを生成
        let _path = paths[0].stringByAppendingPathComponent("sample.db")
        
        // FMDatabaseクラスのインスタンスを作成
        // 引数にファイルまでのパスを渡す
        let db = FMDatabase(path: _path)
        let sql = "CREATE TABLE IF NOT EXISTS sample (user_id INTEGER PRIMARY KEY, user_name TEXT);"
        
        // データベースをオープン
        db.open()
        // SQL文を実行
        let ret = db.executeUpdate(sql, withArgumentsInArray: nil)
        // データベースをクローズ
        db.close()
        
        if ret {
            println("テーブルの作成に成功")
        }
    }
}
