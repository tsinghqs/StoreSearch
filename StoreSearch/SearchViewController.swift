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
    //function to parse through the json data recieved
    func parse(json: String) -> [String: Any]? {
        guard let data = json.data(using: .utf8, allowLossyConversion: false)
            else { return nil}
        
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }
    func iTunesURL(searchText: String) -> URL {
        let escapedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(format:"https://itunes.apple.com/search?term=%@",escapedSearchText)
        let url = URL(string: urlString)
        return url!
    }
    func performStoreRequest(with url: URL) -> String? {
        do {
            return try String(contentsOf: url, encoding: .utf8)
        } catch {
            print("Download Error: \(error)")
            return nil
        }
    }
}

extension SearchViewController: UITableViewDelegate {
        //to be implemented
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        searchResults = []
        
        let url = iTunesURL(searchText: searchBar.text!)
        print("URL: '/(url)'")
        if let jsonString = performStoreRequest(with: url) {
            print("Recieved JSON string'\(jsonString)'")
            if let jsonDictionary = parse(json: jsonString) {
                print("Dictionary \(jsonDictionary)")
            }
        }
        
        tableView.reloadData()
        
    }
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}


