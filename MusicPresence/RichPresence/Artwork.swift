import CryptoKit
import iTunesLibrary

//class MusicLibrary {
//    private let logger = createLogger("Music Library")
//
//    private let lib: ITLibrary
//
//    init() throws {
//        guard let lib = try? ITLibrary(apiVersion: "1.0") else {
//            fatalError("Failed to initialize Music Library!")
//        }
//        self.lib = lib
//    }
//
//    deinit {
//        lib.unloadData()
//    }
//
//    func getArtwork(artist artistName: String, track trackName: String) async
//        -> URL?
//    {
//        let foundTrack = lib.allMediaItems.first { item in
//            item.hasArtworkAvailable && item.artist?.name == artistName
//                && item.title == trackName
//        }
//        guard
//            let artwork = foundTrack?.artwork,
//            let imageData = artwork.imageData
//        else {
//            return nil
//        }
//        
//        let imageFormat = artwork.imageDataFormat
//
//        let hash = CryptoKit.SHA256.hash(data: imageData)
//    }
//}
