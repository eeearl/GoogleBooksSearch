//
//  SearchWord.swift
//  GoogleBooksSearch
//
//  Created by ParkHanul on 27/10/19.
//  Copyright © 2019 eeearl. All rights reserved.
//

import Foundation
import GRDB

struct SearchWord {
    var id: Int64?
    var word: String
}

extension SearchWord: Hashable {}

// MARK: - Persistence

extension SearchWord: Codable, FetchableRecord, MutablePersistableRecord {
    
    // Define database columns from CodingKeys
    private enum Columns {
        static let id = Column(CodingKeys.id)
        static let word = Column(CodingKeys.word)
    }

    // Update a player id after it has been inserted in the database.
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

// MARK: - Database access

extension SearchWord {
    static func insertSearchedWord(word: String) throws {
        try dbQueue.write { db in
            try db.execute(sql: "INSERT INTO SearchWord (word) VALUES (?)", arguments: [word])
        }
    }
    
    static func orderedByWord(containWord: String?) -> [SearchWord] {
        
        do {
            
            if containWord == nil {
                return try dbQueue.read { db in
                    try SearchWord.fetchAll(db)
                }
            }
            
            let containWord = containWord ?? ""
            
            return try dbQueue.read { db in
                try SearchWord
                    .filter(
                        containWord.isEmpty ?
                            Column("word") != nil
                            : Column("word").lowercased.like("%\(containWord)%")
                    )
                    .fetchAll(db)
            }
        } catch {
            return []
        }
    }
}
