//
//  BooksVolumeResponse.swift
//  GoogleBooksSearch
//
//  Created by ParkHanul on 22/10/19.
//  Copyright © 2019 eeearl. All rights reserved.
//

import Foundation

// MARK: - BooksVolumeResponse
struct BooksVolumeResponse: Decodable {
    let kind: String
    let totalItems: Int64
    let items: [SearchResult]?
}

struct SearchResult: Decodable {
    let volumeInfo: BooksItem
}

// MARK: - BookDisplayable Type
protocol BookDisplayable {
    var title: String? { get }
    var pages: Int? { get }
    var authorsName: String { get }
    var thumbnailURL: URL? { get }
}

// MARK: - BooksItem
struct BooksItem: Decodable {
    let title: String?
    let pageCount: Int?
    let authors: [String]?
    let imageLinks: Image?
}

extension BooksItem: BookDisplayable {
    var pages: Int? {
        guard let pageCount = pageCount else { return 0 }
        return pageCount
    }
    
    var authorsName: String {
        guard let authors = authors else { return "Unknown Author" }
        return authors.joined(separator: ", ")
    }
    
    var thumbnailURL: URL? { imageLinks?.thumbnail }
}

struct Image: Decodable {
    let smallThumbnail: URL
    let thumbnail: URL
}
