//
//  MusicItemModel.swift
//  MusicSearch_UIKit
//
//  Created by Neslihan Doğan Aydemir on 2022-12-06.
//

import Foundation

public struct MusicItemModel: Codable, Identifiable {
    
    public let id : Int
    public let wrapperType: WrapperType
    public let kind: String
    public let trackName: String
    public let artistName: String
    public let collectionName: String
    public let artworkUrl100: String
    public let artworkUrl60: String
    public let previewUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case wrapperType
        case kind
        case trackName
        case artistName
        case collectionName
        case artworkUrl100
        case artworkUrl60
        case previewUrl
    }
}
public enum WrapperType: String, Codable {
    case track
    case collection
    case artist
}

var item1 = MusicItemModel(
    id:123124,
    wrapperType: WrapperType.track,
    kind: "song",
    trackName: "Upside Down",
    artistName: "Jack Johnson",
    collectionName: "Sing-a-Longs and Lullabies for the Film Curious George",
    artworkUrl100: "http://a1.itunes.apple.com/r10/Music/3b/6a/33/mzi.qzdqwsel.100x100-75.jpg",
    artworkUrl60: "http://a1.itunes.apple.com/r10/Music/3b/6a/33/mzi.qzdqwsel.60x60-50.jpg",
    previewUrl: "http://a1099.itunes.apple.com/r10/Music/f9/54/43/mzi.gqvqlvcq.aac.p.m4p"
)
var item2 = MusicItemModel(
    id:123125,
    wrapperType: WrapperType.track,
    kind: "song",
    trackName: "Upside Down2",
    artistName: "Jack Johnson2",
    collectionName: "Sing-a-Longs and Lullabies for the Film Curious George",
    artworkUrl100: "http://a1.itunes.apple.com/r10/Music/3b/6a/33/mzi.qzdqwsel.100x100-75.jpg",
    artworkUrl60: "http://a1.itunes.apple.com/r10/Music/3b/6a/33/mzi.qzdqwsel.60x60-50.jpg",
    previewUrl: "http://a1099.itunes.apple.com/r10/Music/f9/54/43/mzi.gqvqlvcq.aac.p.m4p"
)
var musicItemList = [item1,item2]

extension MusicItemModel {
    static func getMockMusicItems() -> [MusicItemModel] {
        return musicItemList
    }
}
