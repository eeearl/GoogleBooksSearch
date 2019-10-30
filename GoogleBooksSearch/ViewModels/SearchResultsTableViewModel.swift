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
    
    var searchTextObserver: Observable<[String]>!
    var searchResultObserver: Observable<[String]>!
    
    init() {
        searchTextObserver = searchText
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<[String]> in
                return self.searchHistory(query).catchErrorJustReturn([])
            }
            .observeOn(MainScheduler.instance)
            .map { $0 }
        
        searchResultObserver = searchResult
            .distinctUntilChanged()
    }
    
    func searchHistory(_ query: String?) -> Observable<[String]> {
        let searchWord = query ?? ""
        return Observable<[String]>
            .from(optional:
                searchWord.isEmpty ? Storage.readHistories().word : Storage.readHistories().word.filter { $0.contains(searchWord) }
            )
    }
}
