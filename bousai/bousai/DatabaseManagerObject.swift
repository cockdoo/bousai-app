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
        
        sql = "CREATE TABLE IF NOT EXISTS livingarea (lat char(10), lon char(10), place TEXT);"
        let ret2 = db.executeUpdate(sql, withArgumentsInArray: nil)
        
        sql = "CREATE TABLE IF NOT EXISTS distinctArea (lat char(10), lon char(10), place TEXT, times char(5));"
        let ret3 = db.executeUpdate(sql, withArgumentsInArray: nil)
        db.close()
        
        if ret3 {
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
    
    func showLocationData(){
        db.open()
        var sql = "SELECT id, lat, lon FROM location ORDER BY id;"
        let results = db.executeQuery(sql, withArgumentsInArray: nil)
        
        while results.next() {
            let id = results.intForColumn("id")
            let lat = results.doubleForColumn("lat")
            let lon = results.doubleForColumn("lon")
            // print data
            println("lat:\(lat) lon:\(lon)")
            
//            lManager.revGeocoding(lat, lon: lon)
        }
        db.close()
    }
    
    func getLocationData() {
        db.open()
        var sql = "SELECT id, lat, lon FROM location ORDER BY id;"
        let results = db.executeQuery(sql, withArgumentsInArray: nil)
        
        while results.next() {
            let id = results.intForColumn("id")
            let lat = results.doubleForColumn("lat")
            let lon = results.doubleForColumn("lon")
            // print data
            println("lat:\(lat) lon:\(lon)")
            
            lManager.revGeocoding(lat, lon: lon)
        }
        db.close()
    }
    
    func insertToLivingAreaTable(lat: Double, lon:Double, locality: String, sublocality: String) {
        db.open()
        var sql = "INSERT INTO livingarea (lat, lon, place) VALUES (?, ?, ?);"
        db.executeUpdate(sql, withArgumentsInArray: [lat, lon, locality + "-" + sublocality])
        db.close()
    }
    
    func getDataCount(tableName: String) {
        db.open()
        var sql = "SELECT COUNT(*) as count FROM \(tableName);"
        let results = db.executeQuery(sql, withArgumentsInArray: nil)
        
        while results.next() {
            let count = results.intForColumn("count")
            locationTableRows = Int(count)
            
        }
        
        db.close()
    }
    
    func getDistinctPlaceList() {
        db.open()
        var sql = "SELECT DISTINCT place FROM livingarea;"
        let results = db.executeQuery(sql, withArgumentsInArray: nil)
        
        var sql3 = "DELETE FROM distinctArea;"
        let results3 = db.executeUpdate(sql3, withArgumentsInArray: nil)
        
        while results.next() {
            let placeName = results.stringForColumn("place")
            
            var sql2 = "SELECT COUNT(place) as count FROM livingarea WHERE place = '\(placeName)';"
            let results2 = db.executeQuery(sql2, withArgumentsInArray: nil)
            
            var count: Int!
            while results2.next() {
                count = Int(results2.intForColumn("count"))
            }
            
            println("\(placeName) : \(count)回")
            
            var sql4 = "SELECT lat, lon FROM livingarea WHERE place = '\(placeName)'"
            let results4 = db.executeQuery(sql4, withArgumentsInArray: nil)
            var lat, lon: Double!
            while results4.next() {
                lat = results4.doubleForColumn("lat")
                lon = results4.doubleForColumn("lon")
            }
            
            println("\(placeName) \(lat) \(lon)")
            
            var sql5 = "INSERT INTO distinctArea (lat, lon, place, times) VALUES (?, ?, ?, ?);"
            db.executeUpdate(sql5, withArgumentsInArray: [lat, lon, placeName, count])
        }
        db.close()
    }
    
    func getDistinctArea() -> Array<Any> {
        db.open()
        var sql = "SELECT lat, lon, place FROM distinctArea ORDER BY times desc;"
        let results = db.executeQuery(sql, withArgumentsInArray: nil)
        
        var array: [Any] = []
        while results.next() {
            let lat: Double = Double(results.doubleForColumn("lat"))
            let lon: Double = results.doubleForColumn("lon")
            let place: String = results.stringForColumn("place")
            
            println("\(place) \(lat) \(lon)!!!!!!!!!!")
            
            var areaArray: NSArray = [lat, lon, place]
            array.append(areaArray)
        }
        
        db.close()
        
        return array
    }
    
    func showPlaceList() {
        db.open()
        var sql = "SELECT place FROM livingarea ORDER BY id;"
        let results = db.executeQuery(sql, withArgumentsInArray: nil)
        
        while results.next() {
            let id = results.stringForColumn("place")
            // print data
            println("place:\(id)")
        }
        
        db.close()
    }
    
    func showTableList() {
        db.open()
        var sql = "SELECT * FROM sqlite_master;"
        let ret = db.executeQuery(sql, withArgumentsInArray: nil)
        while ret.next() {
            let id = ret.stringForColumn("name")
            // print data
            println("place:\(id)")
        }
        db.close()
    }
    
    func deleteTable(tableName: String) {
        db.open()
        var sql = "DROP TABLE livingarea;"
        let ret = db.executeUpdate(sql, withArgumentsInArray: nil)
        db.close()
    }
    
    func truncateTable(tableName: String) {
        db.open()
        var sql = "DELETE FROM \(tableName);"
        let ret = db.executeUpdate(sql, withArgumentsInArray: nil)
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
