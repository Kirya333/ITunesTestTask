//
//  HistoryTabViewController.swift
//  ITunesTestTask
//
//  Created by Кирилл Тарасов on 02.11.2021.
//

import UIKit

class HistoryTabViewController: UITableViewController {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var searchHistory = [SearchRequest]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            searchHistory = try context.fetch(SearchRequest.fetchRequest())
        } catch let error as NSError {
        print("could not fetch, error: \(error)")
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Basic Cell", for: indexPath)
        let path = searchHistory.count-indexPath.row-1
        cell.textLabel?.text = searchHistory[path].text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "RepeatSearch", sender: cell)
    }
    



    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RepeatSearch" {
            if let destinationController = segue.destination as? SearchResultsViewController,
               let cell = sender as? UITableViewCell{
                destinationController.searchText = (cell.textLabel?.text)!
            }
        }
    }

}
