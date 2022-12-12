import UIKit
import SwiftUI

class MainViewController: UITableViewController {
    
    var musicItemList = MusicItemModel.getMockMusicItems()
    private let viewModel = ContentViewModel()
    private let imageDownloader = ImageDownloader()
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
    
    func getImage(url: String) async -> UIImage {
        var image = UIImage()
        do {
            image = try await imageDownloader.getImage(url: url)
        } catch {
            print(error)
        }
        return image
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.state.results?.count ?? 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "SegueForMusicDetails",
            let indexPath = tableView.indexPathForSelectedRow,
            let detailViewController = segue.destination as? DetailViewController
        else {
            return
        }
        let musicItem = viewModel.state.results?[indexPath.row]
        detailViewController.musicItem = musicItem
    }
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        guard let musicItem = viewModel.state.results?[indexPath.row] else {
    //            fatalError("Oh no should not happen")
    //        }
    //        let detailView = DetailViewController.detailViewControllerWithItem(musicItem)
    //        navigationController?.pushViewController(detailView, animated: true)
    //        tableView.deselectRow(at: indexPath, animated: true)
    //    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicItemIdentifier", for: indexPath) as! MusicCell
        guard let musicItem = viewModel.state.results?[indexPath.row] else {
            fatalError("Oh no should not happen")
        }
        /*
        let trackLabel = cell.viewWithTag(1000) as! UILabel
        trackLabel.text = musicItem.trackName
        let artistLabel = cell.viewWithTag(1001) as! UILabel
        artistLabel.text = musicItem.artistName
        let image = cell.viewWithTag(2001) as! UIImageView
        let outerView = cell.viewWithTag(2000)!
        
        image.adjustsImageSizeForAccessibilityContentSizeCategory = true
        image.applyShadow(containerView: outerView,coefficient: 0.3)
        Task {
            image.image = await getImage(url: musicItem.artworkUrl60)
        }
        */
        cell.artistName.text = musicItem.artistName
        
        return cell
    }
}
class MusicCell: UITableViewCell {
    
    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var trackName: UILabel!
}
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchKey = searchController.searchBar
        viewModel.keyword = searchKey.text!
        
    }
}
