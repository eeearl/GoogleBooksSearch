//
//  Database.swift
//  GoogleBooksSearch
//
//  Created by ParkHanul on 27/10/19.
//  Copyright © 2019 eeearl. All rights reserved.
//

import Foundation

class Storage {
    
    private static let historyFilePath = "history.plist"
    
    static func writeHistory(searchWord: String) throws {

        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml

        let path = try FileManager.default
            .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent(historyFilePath)
        
        var histories = readHistories()
        if histories.word.contains(searchWord) {
            return
        }
        
        histories.word.append(searchWord)
        
        let data = try encoder.encode(histories)
        try data.write(to: path)
    }
    
    static func readHistories() -> SearchHistory {
        do {
            let decoder = PropertyListDecoder()
            
            let path = try FileManager.default
                .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(historyFilePath)
            
            if let data = try? Data(contentsOf: path) {
                guard let searchWords = try? decoder.decode(SearchHistory.self, from: data) else { return SearchHistory(word: []) }
                return searchWords
            }
            
        } catch {
        }
        
        return SearchHistory(word: [])
    }
}
