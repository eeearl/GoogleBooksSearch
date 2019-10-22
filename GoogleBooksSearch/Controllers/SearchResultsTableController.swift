//
//  SearchResultsTableController.swift
//  GoogleBooksSearch
//
//  Created by ParkHanul on 22/10/19.
//  Copyright © 2019 eeearl. All rights reserved.
//

import UIKit

class SearchResultsTableController: UITableViewController {
    
    let cellIdentifier = "SearchResultsCell"
    let viewModel = SearchResultsTableViewModel()
    
    override func viewDidLoad() {
       super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

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
