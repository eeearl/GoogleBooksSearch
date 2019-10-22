//
//  ViewController.swift
//  GoogleBooksSearch
//
//  Created by ParkHanul on 22/10/19.
//  Copyright © 2019 eeearl. All rights reserved.
//

import UIKit

class BookSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = BookSearchViewModel()
    lazy var searchController: SearchResultsTableController = {
       return SearchResultsTableController()
    }()

    var searchedTexts = ["Data1","Data2","Data3"]
    
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
        let search = UISearchController(searchResultsController: searchResultsController)
        search.searchResultsUpdater = self
        search.searchBar.delegate = self
        self.navigationItem.searchController = search

        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    func bindViews() {
        tableView.dataSource = viewModel
    }
}

extension BookSearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
    // MARK: UISearchResultsUpdating
    // Update the filtered array based on the search text.
    func updateSearchResults(for searchController: UISearchController) {
        let filteredResults = searchedTexts.filter({ company in
            guard let searchingTxt = searchController.searchBar.text?.lowercased() else {
                return false
            }
            return company.lowercased().contains(searchingTxt)
        })

        // Hand over the filtered results to our search results table.
        guard let resultsController = searchController.searchResultsController as? SearchResultsTableController else {
            return
        }
        
        resultsController.viewModel.searchResult.value = filteredResults
        resultsController.tableView.reloadData()
    }
    
    // MARK: UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        self.navigationItem.searchController?.dismiss(animated: true, completion: nil)
        
        GoogleBooksAPI().request(searchText: text, startIndex: 0, resultCount: 3) { books in
            self.viewModel.searchResult.value = books
            self.tableView.reloadData()
        }
    }
}
