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
    //function to parse through the json data recieved sugoily
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
    
    func parse(dictionary: [String: Any]) {
        //1
        guard let array = dictionary["results"] as? [Any] else {
            print("Expected 'results' array")
            return
        }
        //2
        //var searchResults: [SearchResult] = []
        for resultDict in array {
            //3
            if let resultDict = resultDict as? [String: Any] {
                var searchResult: SearchResult?
                if let wrapperType = resultDict["wrapperType"] as? String {
                    switch wrapperType {
                    case "track":
                        searchResult = parse(track: resultDict)
                    default:
                        break
                    }
                }
                if let result = searchResult {
                    searchResults.append(result)
                }
            }
        }
        //return searchResults

    }
    
    //instantiate new searchResult object
    //get values out of dictionary and put them in searchResult properties
    func parse(track dictionary: [String: Any]) -> SearchResult {
        let searchResult = SearchResult()
        
        searchResult.name = dictionary["trackName"] as? String ?? ""
        searchResult.artistName = dictionary["artistName"] as? String ?? ""
        searchResult.artworkSmallURL = dictionary["artworkURL60"] as? String ?? ""
        searchResult.artworkLargeURL = dictionary["artworkUrl100"] as? String ?? ""
        searchResult.storeURL = dictionary["trackViewUrl"] as? String ?? ""
        searchResult.kind = dictionary["kind"] as? String ?? ""
        searchResult.currency = dictionary["currency"] as? String ?? ""
        
        if let price = dictionary["trackPrice"] as? Double {
            searchResult.price = price
        }
        if let genre = dictionary["primaryGenreName"] as? String {
            searchResult.genre = genre
        }
        return searchResult
        
    }
    
    //Getting the URL from bada sankrei
    func iTunesURL(searchText: String) -> URL {
        let escapedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(format:"https://itunes.apple.com/search?term=%@",escapedSearchText)
        let url = URL(string: urlString)
        return url!
    }
    
    //method to handle network errors senpai
    func showNetworkError() {
        let alert = UIAlertController(
            title: "Well Damn...",
            message: "There was an error reading from the iTunes Store. Please try again.",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
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


//Extensions go here |||
//                   vvv
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
                parse(dictionary: jsonDictionary)
                tableView.reloadData()
                return
            }
        }
        showNetworkError()
        
        
    }
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}


