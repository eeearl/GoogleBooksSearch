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
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationbar()
        initSearchbar()
        bindViews()
    }
    
    func initNavigationbar() {
        self.title = "Search"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
    
    func initSearchbar() {
        let searchResultsController = SearchResultsTableController()
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        searchResultsController.searchResultCallback = self
        
        
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    func bindViews() {
        viewModel.searchResult
            .bind(to: tableView.rx.items(cellIdentifier: BookSearchCell.identifier, cellType: BookSearchCell.self)) { tableView, item, cell in
                
                if let thumbnailUrl = item.thumbnail, let url = URL(string: thumbnailUrl) {
                    cell.bookCoverImg.kf.setImage(with: url)
                }
                
                cell.bookTitle.text = item.title
                cell.bookAuthor.text = item.authors?.reduce("") { (result, s) -> String in
                    return result.isEmpty ? s : "\(result), \(s)"
                }
                cell.bookPages.text = "\(item.pageCount)p"
                
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
        self.navigationItem.searchController?.dismiss(animated: true, completion: nil)
        
        do {
            try SearchWord.insertSearchedWord(word: text)
        } catch {
            
        }
        
        viewModel.requestBookSearch(text, resetIndex: true)
    }
}

extension BookSearchViewController: SearchResultCallback {
    func clickedSearchResultItem(selectedItemModel: String) {
        if let searchController = self.navigationItem.searchController {
            searchController.searchBar.text = selectedItemModel
        }
        
        viewModel.requestBookSearch(selectedItemModel, resetIndex: true)
    }
}
