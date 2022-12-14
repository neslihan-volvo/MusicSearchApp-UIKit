import UIKit
import SwiftUI

class MainViewController: UITableViewController {
    
    var musicItemList = MusicItemModel.getMockMusicItems()
    private let viewModel = ContentViewModel()
    private let imageDownloader = ImageDownloader()
    let searchController = UISearchController(searchResultsController: nil)
    var imageTasks = [IndexPath:Task<Void,Never>]()
    
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
            print("get image resulted error")
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
    // creating segue with code
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let musicItem = viewModel.state.results?[indexPath.row] else {
            fatalError("Oh no should not happen")
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(withIdentifier: "MusicDetails") as! DetailViewController
        detailViewController.musicItem = musicItem
        navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicItemIdentifier", for: indexPath) as! MusicCell
        guard let musicItem = viewModel.state.results?[indexPath.row] else {
            fatalError("Oh no should not happen")
        }
        cell.artistName.text = musicItem.artistName
        cell.trackName.text = musicItem.trackName
        imageTasks[indexPath]?.cancel()
        let myTask = Task {
            
            @MainActor in
            cell.musicImage.image = await getImage(url: musicItem.artworkUrl60)
            cell.musicImage.applyShadow(containerView: cell.containerView, coefficient: 0.5)
            cell.musicImage.contentMode = .scaleAspectFill
        }
        imageTasks[indexPath] = myTask
        return cell
    }
}

//instead of reaching cells with viewWithTag we can use class
class MusicCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var trackName: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("prepare for reuse is called")
    }
}
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchKey = searchController.searchBar
        viewModel.keyword = searchKey.text!
        
    }
}
