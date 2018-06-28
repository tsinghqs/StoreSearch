//
//  ViewController.swift
//  StoreSearch
//
//  Created by Tarun Singh on 6/27/18.
//  Copyright © 2018 Tarun Singh. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var searchResults: [SearchResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let cellNib = UINib(nibName: "SearchResultCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "SearchResultCell")
        tableView.rowHeight = 80
        searchBar.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    }
extension SearchViewController: UITableViewDataSource{
    //to be implemented
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
        }
    }
    func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultCell
        
        if searchResults.count == 0 {
            cell.nameLabel.text = "(Nothing Found)"
            cell.artistNameLabel.text = ""
        } else {
            let searchResult = searchResults[indexPath.row]
            cell.nameLabel.text = searchResult.name
            cell.artistNameLabel.text = searchResult.artistName
        }
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
        //to be implemented
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        for i in 0...2 {
            let searchResult = SearchResult()
            searchResult.name = (String(format: "Fake Result %d for '%@'", i))
            searchResult.artistName = searchBar.text!
            searchResults.append(searchResult)
            
        }
        
        tableView.reloadData()
        
    }
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}


