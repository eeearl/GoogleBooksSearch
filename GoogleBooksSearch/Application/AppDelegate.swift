//
//  AppDelegate.swift
//  GoogleBooksSearch
//
//  Created by ParkHanul on 22/10/19.
//  Copyright © 2019 eeearl. All rights reserved.
//

import UIKit
import GRDB

// The shared database queue
var dbQueue: DatabaseQueue!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       try! setupDatabase(application)
        return true
    }
    
    private func setupDatabase(_ application: UIApplication) throws {
        dbQueue = try Database.openDatabase()
        dbQueue.setupMemoryManagement(in: application)
    }
}
