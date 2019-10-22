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
        
        cell.bookTitle.text = searchResult.value[indexPath.row].title
        
        return cell
    }
}
