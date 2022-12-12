import Foundation

protocol NetworkClient: AnyObject {
    func load(request: URLRequest) async throws -> (Data, URLResponse)
}

class DefaultNetworkClient: NetworkClient {
    
    func load(request: URLRequest) async throws -> (Data, URLResponse) {
        let session = URLSession.shared
        do{
            return try await session.data(for: request)
        }
        catch{
            throw MusicSearchError.requestFailed
        }
    }
}
extension NetworkClient {
    func load(path: String) async throws -> (Data, URLResponse) {
        guard let url = URL(string: path)
        else {
            throw MusicSearchError.urlInvalid
        }
        let request = URLRequest(url: url)
        return try await load(request: request)
    }
}
