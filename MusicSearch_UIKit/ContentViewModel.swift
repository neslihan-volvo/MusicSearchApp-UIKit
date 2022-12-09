import Foundation

class ContentViewModel {
    let networkClient: NetworkClient
    private var currentTask: Task<Void, Never>?
    var onStateDidChange: () -> Void = {}
    
    var state: State = .idle {
        didSet {
            guard oldValue != state else { return }
            onStateDidChange()
        }
    }
    var keyword = "" {
        didSet {
            guard oldValue != keyword else { return }
            onKeywordDidChange()
        }
    }
    
    private func onKeywordDidChange() {
        let keyword = keyword
        currentTask?.cancel()
        currentTask = Task {
            await loadResults(keyword)
        }
    }
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func loadResults(_ searchKey: String) async {
        let key = searchKey.makeSearchString()
        let urlPath = "https://itunes.apple.com/search?term=\(key)&media=music"
        await MainActor.run {
            state = .loading
        }
        do {
            let (data, response) = try await networkClient.load(path: urlPath)
            try Task.checkCancellation()
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode)
            else {
                throw MusicSearchError.networkResponseInvalid
            }
            
            let musicSearchResponse = try JSONDecoder().decode(MusicSearchResponse.self, from: data)
            await MainActor.run {
                state = .loaded(results: musicSearchResponse.results)
            }
        } catch is CancellationError {
            print("cancelled")
        } catch {
            await MainActor.run {
                state = .error
            }
        }
    }
}
