//
//  SearchResultsTableViewModel.swift
//  GoogleBooksSearch
//
//  Created by ParkHanul on 22/10/19.
//  Copyright © 2019 eeearl. All rights reserved.
//

import RxSwift
import RxCocoa

class SearchResultsTableViewModel {
    
    let searchResult = BehaviorRelay<[String]>(value: [])
    let searchText = BehaviorRelay<String?>(value: "")
}
