//
//  SearchResultsTableController.swift
//  GoogleBooksSearch
//
//  Created by ParkHanul on 22/10/19.
//  Copyright © 2019 eeearl. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SearchResultCallback {
    func clickedSearchResultItem(selectedItemModel: String)
}

class SearchResultsTableController: UITableViewController {
    
    let cellIdentifier = "SearchResultsCell"
    let viewModel = SearchResultsTableViewModel()
    let disposeBag = DisposeBag()
    
    var searchResultCallback: SearchResultCallback? = nil
    
    override func viewDidLoad() {
       super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        bindViews()
    }
    
    func bindViews() {

        viewModel.searchText
            .throttle(.milliseconds(800), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<[SearchWord]> in
                return self.searchHistory(query).catchErrorJustReturn([])
            }
            .observeOn(MainScheduler.instance)
            .map { $0.map { $0.word } }
            .bind(to: viewModel.searchResult)
            .disposed(by: disposeBag)
        
        viewModel.searchResult
            .distinctUntilChanged()
            .bind(onNext: {_ in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        tableView.rx
            .itemSelected
            .subscribe(onNext: { indexPath in
                let word = self.viewModel.searchResult.value[indexPath.row]
                self.searchResultCallback?.clickedSearchResultItem(selectedItemModel: word)
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    func searchHistory(_ query: String?) -> Observable<[SearchWord]> {
        return Observable<[SearchWord]>.from(optional: SearchWord.orderedByWord(containWord: query))
    }
}

// MARK: - TableView Datasource

extension SearchResultsTableController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResult.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        let index = indexPath.row
        cell.textLabel?.text = viewModel.searchResult.value[index].description

        return cell
    }

}
