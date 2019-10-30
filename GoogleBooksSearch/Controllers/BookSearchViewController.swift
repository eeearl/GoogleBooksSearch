//
//  ViewController.swift
//  GoogleBooksSearch
//
//  Created by ParkHanul on 22/10/19.
//  Copyright © 2019 eeearl. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class BookSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = BookSearchViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationbar()
        initSearchbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        disposeBag = DisposeBag()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindViews()
    }
    
    func initNavigationbar() {
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func initSearchbar() {
        let searchResultsController = SearchResultsTableController()
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchResultsController.searchResultDelegate = self
        navigationItem.searchController = searchController
    }
    
    func bindViews() {
        viewModel.searchResult
            .bind(to: tableView.rx.items(cellIdentifier: BookSearchCell.identifier, cellType: BookSearchCell.self)) { tableView, item, cell in
                cell.bookCoverImg.kf.setImage(with: item.thumbnailURL)
                cell.bookTitle.text = item.title
                cell.bookAuthor.text = item.authorsName
                cell.bookPages.text = "\(item.pages ?? 0)p"
            }
            .disposed(by: disposeBag)
    }
}

extension BookSearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    // MARK: UISearchResultsUpdating
    // Update the filtered array based on the search text.
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsTableController else {
            return
        }
        
        resultsController.viewModel.searchText.accept(searchController.searchBar.text)
    }
    
    // MARK: UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        navigationItem.searchController?.dismiss(animated: true, completion: nil)
        
        do {
            try Storage.writeHistory(searchWord: text)
        } catch {
            
        }
        
        viewModel.requestBookSearch(text, resetIndex: true)
    }
}

extension BookSearchViewController: SearchResultDelegate {
    func clickedSearchResultItem(selectedItemModel: String) {
        if let searchController = navigationItem.searchController {
            searchController.searchBar.text = selectedItemModel
        }
        
        viewModel.requestBookSearch(selectedItemModel, resetIndex: true)
    }
}
