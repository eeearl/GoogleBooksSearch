//
//  BookSearchViewModel.swift
//  GoogleBooksSearch
//
//  Created by ParkHanul on 22/10/19.
//  Copyright © 2019 eeearl. All rights reserved.
//

import RxSwift
import RxCocoa

class BookSearchViewModel {
    
    let disposeBag = DisposeBag()
    let searchResult = BehaviorRelay<[BookDisplayable]>(value: [])
    let query = BehaviorRelay<String>(value: "")
    
    private var reqStartIndex = 0
    private var resultCount = 20
    
    init() {}
    
    func requestBookSearch(_ text: String, resetIndex: Bool?) {
        if let _ = resetIndex { reqStartIndex = 0 }
        let _ = GoogleBooksAPI()
                .request(searchText: text, startIndex: reqStartIndex, resultCount: resultCount)
                .subscribe(onNext: { books in
                    self.searchResult.accept(books)
                    self.reqStartIndex = self.searchResult.value.count
                })
    }
}
