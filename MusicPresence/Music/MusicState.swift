import Foundation

struct MusicState: Equatable {
    let trackName: String
    let artistName: String
    let albumName: String

    let elapsedSeconds: TimeInterval
    let durationSeconds: TimeInterval

    let updatedAt: Date

    init(
        trackName: String,
        artistName: String,
        albumName: String,
        elapsedSeconds: TimeInterval,
        durationSeconds: TimeInterval,
        updatedAt: Date = .now
    ) {
        self.trackName = trackName
        self.artistName = artistName
        self.albumName = albumName

        self.elapsedSeconds = elapsedSeconds
        self.durationSeconds = durationSeconds

        self.updatedAt = updatedAt
    }
}
