//
//  SearchTabViewController.swift
//  ITunesTestTask
//
//  Created by Кирилл Тарасов on 02.11.2021.
//


import UIKit

class SearchTabViewController: CustomCollectionViewController {

    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem!.isEnabled = false
        searchBar.becomeFirstResponder()
        
    }

    private func addSearchRequestToHistory(searchText: String) {
        let newRequest = SearchRequest(entity: SearchRequest.entity(), insertInto: context)
        newRequest.text = searchText
        appDelegate.saveContext()
    }
    
    override func cancelButtonTapped() {
        super.cancelButtonTapped()
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

}

// MARK: Search Bar Delegate
extension SearchTabViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            navigationItem.rightBarButtonItem!.isEnabled = true
            searchBar.resignFirstResponder()
            NetworkSession.dataTask?.cancel()
            downloadTask?.cancel()
            addSearchRequestToHistory(searchText: searchBar.text!)
            searchResults = []
            collectionView.reloadData()
            spinner.startAnimating()
            findAlbums(searchText: searchBar.text!)
        }
    }
}


