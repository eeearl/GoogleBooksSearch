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
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    var reachedBottomTrigger = PublishSubject<Void>()
    
    private var reqStartIndex = 0
    private var resultCount = 20
    private var shouldLoadNextPage = BehaviorRelay<Bool>(value: false)
    
    init() {
        reachedBottomTrigger
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .withLatestFrom(isLoading)
            .filter { !$0 }
            .withLatestFrom(shouldLoadNextPage)
            .filter { $0 }
            .subscribe { b in
                self.requestNextPage()
            }.disposed(by: disposeBag)
    }
    
    func requestBookSearch(_ text: String, resetIndex: Bool?) {
        if let reset = resetIndex {
            if reset {
                reqStartIndex = 0
            }
        }
        query.accept(text)
        
        let _ = GoogleBooksAPI()
                .request(searchText: text, startIndex: reqStartIndex, resultCount: resultCount)
                .do(onNext: { _ in
                    self.isLoading.accept(true)
                })
                .subscribe(onNext: { books in
                    self.isLoading.accept(false)
                    self.searchResult.accept(books.items)
                    self.shouldLoadNextPage.accept(books.totalItems > 0)
                    self.reqStartIndex = self.searchResult.value.count
                })
    }
    
    func requestNextPage() {
        let _ = GoogleBooksAPI()
            .request(searchText: query.value, startIndex: reqStartIndex, resultCount: resultCount)
            .do(onNext: { _ in
                self.isLoading.accept(true)
            })
            .subscribe(onNext: { books in
                self.isLoading.accept(false)
                self.searchResult.accept(self.searchResult.value + books.items)
                self.shouldLoadNextPage.accept(books.totalItems > 0)
                self.reqStartIndex = self.searchResult.value.count
            })
    }
}
