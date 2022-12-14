import Foundation
import UIKit

class ImageDownloader {
    
    let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func getImage(url: String) async throws -> UIImage {
        let (data, response) = try await networkClient.load(path: url)
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode)
        else {
            throw ImageDownloaderError.networkResponseInvalid
        }
        guard let image = UIImage(data: data)
        else {
            throw ImageDownloaderError.imageInitializationFailed
        }
        return image
    }
}
