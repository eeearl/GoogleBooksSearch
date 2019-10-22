//
//  BooksVolumeResponse.swift
//  GoogleBooksSearch
//
//  Created by ParkHanul on 22/10/19.
//  Copyright © 2019 eeearl. All rights reserved.
//

import Foundation

struct BooksVolumeResponse: Codable {
    let kind: String
    let totalItems: Int64
    let items: [BooksItem]?

    enum CodingKeys: String, CodingKey {
        case kind = "kind"
        case totalItems = "totalItems"
        case items = "items"
    }
    
    // Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(kind, forKey: .kind)
        try container.encode(totalItems, forKey: .totalItems)
        try container.encode(items, forKey: .items)
    }
    
     // Decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        kind = try container.decode(String.self, forKey: .kind)
        totalItems = try container.decode(Int64.self, forKey: .totalItems)
        if container.contains(.items) {
            items = try container.decode([BooksItem].self, forKey: .items)
        } else {
            items = nil
        }
    }
}

struct BooksItem: Codable {
    let title: String
    let authors: [String]?
    let thumbnail: String?

    enum CodingKeys: String, CodingKey {
        case volumeInfo = "volumeInfo"
        case title = "title"
        case authors = "authors"
        case imageLinks = "imageLinks"
        case thumbnail = "thumbnail"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let response = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .volumeInfo)
        title = try response.decode(String.self, forKey: .title)
        
        if response.contains(.authors) {
            authors = try response.decode([String]?.self, forKey: .authors)
        } else {
            authors = nil
        }
        
        let imageLinks = try response.nestedContainer(keyedBy: CodingKeys.self, forKey: .imageLinks)
        thumbnail = try imageLinks.decode(String.self, forKey: .thumbnail)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var response = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .volumeInfo)
        try response.encode(title, forKey: .title)
        try response.encode(authors, forKey: .authors)
        var imageLinks = response.nestedContainer(keyedBy: CodingKeys.self, forKey: .imageLinks)
        try imageLinks.encode(thumbnail, forKey: .thumbnail)
        
    }
}
