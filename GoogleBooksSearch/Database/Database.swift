//
//  Database.swift
//  GoogleBooksSearch
//
//  Created by ParkHanul on 27/10/19.
//  Copyright © 2019 eeearl. All rights reserved.
//

import Foundation
import GRDB

class Database {
    
    private static let databasePath = "googlebooks.sqlite"
    
    // Creates a fully initialized database at path
    static func openDatabase() throws -> DatabaseQueue {
        let databaseURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(databasePath)
            
        return try openDatabase(atPath: databaseURL.path)
    }
    
    static func openDatabase(atPath path: String) throws -> DatabaseQueue {
        // Connect to the database
        let dbQueue = try DatabaseQueue(path: path)
        
        // Define the database schema
        try migrator.migrate(dbQueue)
        
        return dbQueue
    }
    
    // The DatabaseMigrator that defines the database schema.
    static var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("createSearchWordTable") { db in
            // Create a table
            try db.create(table: "SearchWord") { t in
                t.autoIncrementedPrimaryKey("id")
                
                // See https://github.com/groue/GRDB.swift/blob/master/README.md#unicode
                t.column("word", .text).notNull()
            }
        }
        
        return migrator
    }
}
