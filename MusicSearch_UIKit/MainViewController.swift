//
//  SearchViewController.swift
//  MusicSearch_UIKit
//
//  Created by Neslihan Doğan Aydemir on 2022-12-06.
//

import UIKit
import SwiftUI

class MainViewController: UITableViewController {
    
    var musicItemList = MusicItemModel.getMockMusicItems()
    private let viewModel = ContentViewModel()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for Music"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        viewModel.onStateDidChange = { [weak self] in
            self?.onStateDidChange()
        }
    }
    
    private func onStateDidChange() {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.state.results?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let musicItem = viewModel.state.results?[indexPath.row] else {
            fatalError("Oh no should not happen")
        }
        print(musicItem)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicItemIdentifier", for: indexPath)
        guard let musicItem = viewModel.state.results?[indexPath.row] else {
            fatalError("Oh no should not happen")
        }
        let trackLabel = cell.viewWithTag(1000) as! UILabel
        trackLabel.text = musicItem.trackName
        let artistLabel = cell.viewWithTag(1001) as! UILabel
        artistLabel.text = musicItem.artistName
        
        // Configure the cell...
        
        return cell
    }
}
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchKey = searchController.searchBar
        viewModel.keyword = searchKey.text!
        
    }
}
