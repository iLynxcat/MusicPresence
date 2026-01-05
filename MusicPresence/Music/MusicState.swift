import Foundation

struct MusicState: Equatable {
    let trackName: String
    let artistName: String
    let albumName: String
    
    let elapsedSeconds: TimeInterval
    let durationSeconds: TimeInterval
}
