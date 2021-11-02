//
//  SearchResultsViewController.swift
//  ITunesTestTask
//
//  Created by Кирилл Тарасов on 02.11.2021.
//


import UIKit

class SearchResultsViewController: CustomCollectionViewController {

    var searchText = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        findAlbums(searchText: searchText)
    }
    
    override func cancelButtonTapped() {
        super.cancelButtonTapped()
        navigationController?.popViewController(animated: true)
    }
}



