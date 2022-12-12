import UIKit
import AVKit
protocol DetailViewControllerDelegate: AnyObject {
  func detailViewController(_ controller: DetailViewController,
                             openDetailedViewOf musicItem: MusicItemModel)
}

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var imageOuterView: UIView!
    
    private let musicPlayer = AVPlayer()
    private let imageDownloader = ImageDownloader()
    weak var delegate: DetailViewControllerDelegate?
    
    var musicItem : MusicItemModel?
    /*var musicItem: MusicItemModel? {
        didSet {
            getMusicITemDetails()
        }
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.setTitle("Play", for: .normal)
        //musicImage.image = UIImage(named: "sampleImage100")
        
        //getMusicITemDetails()
        //getMusicItemDetails(musicItem: musicItem!)
        // Do any additional setup after loading the view.
        if let item = musicItem {
            getMusicItemDetails(musicItem: item)
        }
    }
    
    func getMusicItemDetails(musicItem : MusicItemModel) {
        /*if let musicItem = musicItem,
           let artistName = artistName,
           let trackName = trackName,
           let collectionName = collectionName {
            Task {
                musicImage.image = await getImage(url: musicItem.artworkUrl60)
            }
            
            musicImage.applyShadow(containerView:imageOuterView, coefficient: 0.3)
            artistName.text = musicItem.artistName
            collectionName.text = musicItem.collectionName
            trackName.text = musicItem.trackName
        }*/
        Task {
            musicImage.image = await getImage(url: musicItem.artworkUrl60)
            
            musicImage.applyShadow(containerView:imageOuterView, coefficient: 0.3)
        }
        
        artistName.text = musicItem.artistName
        collectionName.text = musicItem.collectionName
        trackName.text = musicItem.trackName
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
    //    class func detailViewControllerWithItem(_ item: MusicItemModel) -> UIViewController {
    //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //
    //        let viewController =
    //            storyboard.instantiateViewController(withIdentifier: "MusicDetails")
    //
    //        if let detailViewController = viewController as? DetailViewController {
    //            detailViewController.musicItem = item
    //        }
    //
    //        return viewController
    //    }
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //        artistName.text = musicItem.artistName
    //        trackName.text = musicItem.trackName
    //        collectionName.text = musicItem.collectionName
    //
    //
    //    }
    @IBAction func playMusic(_ sender: UIButton) {
        if musicPlayer.rate == 1 {
            musicPlayer.pause()
            playButton.setTitle("Play", for: .normal)
        } else {
            if musicPlayer.currentItem == nil {
                musicPlayer.replaceCurrentItem(with: AVPlayerItem(url: URL(string: musicItem!.previewUrl)!))
            }
            musicPlayer.play()
            playButton.setTitle("Pause", for: .normal)
        }
    }
}
