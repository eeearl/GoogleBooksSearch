//
//  BookSearchViewModel.swift
//  GoogleBooksSearch
//
//  Created by ParkHanul on 22/10/19.
//  Copyright © 2019 eeearl. All rights reserved.
//

import UIKit
import RxSwift

class BookSearchViewModel: NSObject {
    
    let searchResult = Variable<[BooksItem]>([])
}

extension BookSearchViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookSearchCell.identifier) as? BookSearchCell else {
            return UITableViewCell()
        }
        
        if let thumbnailUrl = searchResult.value[indexPath.row].thumbnail {
            if let url = URL(string: thumbnailUrl) {
                URLSession.shared.dataTask(with: url) { data, response, error -> Void in
                    if let error = error {
                        print("Failed fetching image:", error)
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        print("Not a proper HTTPURLResponse or statusCode")
                        return
                    }

                    DispatchQueue.main.async { cell.bookCoverImg.image = UIImage(data: data!) }
                }.resume()
            }
        }
        
        cell.bookTitle.text = searchResult.value[indexPath.row].title
        cell.bookAuthor.text = searchResult.value[indexPath.row].authors?.reduce("") { (result, s) -> String in
            return result.isEmpty ? s : "\(result), \(s)"
        }
        
        return cell
    }
}
