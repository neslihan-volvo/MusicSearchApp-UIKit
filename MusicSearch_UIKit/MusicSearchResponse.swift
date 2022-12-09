import Foundation

public struct MusicSearchResponse: Codable {
    public var resultCount : Int
    public var results : [MusicItemModel]
}
