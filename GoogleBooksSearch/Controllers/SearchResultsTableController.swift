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

protocol SearchResultDelegate: class {
    func clickedSearchResultItem(selectedItemModel: String)
}

class SearchResultsTableController: UITableViewController {
    
    let cellIdentifier = "SearchResultsCell"
    let viewModel = SearchResultsTableViewModel()
    let disposeBag = DisposeBag()
    
    weak var searchResultDelegate: SearchResultDelegate?
    
    override func viewDidLoad() {
       super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        bindViews()
    }
    
    func bindViews() {

        viewModel.searchText
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query -> Observable<[String]> in
                return self.searchHistory(query).catchErrorJustReturn([])
            }
            .observeOn(MainScheduler.instance)
            .map { $0 }
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
                self.searchResultDelegate?.clickedSearchResultItem(selectedItemModel: word)
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    func searchHistory(_ query: String?) -> Observable<[String]> {
        let searchWord = query ?? ""
        return Observable<[String]>
            .from(optional:
                searchWord.isEmpty ? Storage.readHistories().word : Storage.readHistories().word.filter { $0.contains(searchWord) }
            )
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
