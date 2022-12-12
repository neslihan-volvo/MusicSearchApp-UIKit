import UIKit
import AVKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var imageOuterView: UIView!
    
    private let musicPlayer = AVPlayer()
    private let imageDownloader = ImageDownloader()
    
    var musicItem: MusicItemModel? {
        didSet {
            getMusicITemDetails()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.setTitle("Play", for: .normal)
        musicImage.image = UIImage(named: "sampleImage100")
        musicImage.applyShadow(containerView:imageOuterView, coefficient: 0.3)
        
        getMusicITemDetails()
        // Do any additional setup after loading the view.
    }
    func getMusicITemDetails() {
        if let musicItem = musicItem,
           let artistName = artistName,
           let trackName = trackName,
           let collectionName = collectionName {
            Task {
                musicImage.image = await getImage(url: musicItem.artworkUrl60)
            }
            artistName.text = musicItem.artistName
            collectionName.text = musicItem.collectionName
            trackName.text = musicItem.trackName
        }
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
