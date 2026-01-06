import AppKit
import Foundation
import OSLog

private let pollScriptSource = """
    if application "Music" is running then
        tell application "Music"
            set playerState to player state as string
            set trackName to ""
            set trackArtist to ""
            set trackAlbum to ""
            set trackDuration to 0
            set trackPosition to 0
            
            if playerState is not "stopped" then
                try
                    set trackName to name of current track
                    set trackArtist to artist of current track
                    set trackAlbum to album of current track
                    set trackDuration to duration of current track
                    set trackPosition to player position
                end try
            end if
            
            return {playerState, trackName, trackArtist, trackAlbum, trackDuration, trackPosition}
        end tell
    else
        return {"stopped", "", "", "", 0, 0}
    end if
    """
let pollScript: NSAppleScript =
    NSAppleScript(source: pollScriptSource)!

extension MusicWatcher {
    func poll() -> MusicState? {
        let now: Date = .now

        var error: NSDictionary?
        let result = pollScript.executeAndReturnError(&error)

        if let error {
            let errorPrefix = "AppleScript error:"

            if let errorNumber = error["NSAppleScriptErrorNumber"] as? Int {
                if errorNumber == -1743 || errorNumber == -1744 {
                    logger.error(
                        "\(errorPrefix) \(error) (code \(errorNumber), no permission to automate Music)"
                    )
                } else {
                    logger.error(
                        "\(errorPrefix) \(error) (code \(errorNumber))"
                    )
                }
                return nil
            }

            logger.error("\(errorPrefix) \(error)")
            return nil
        }

        guard result.descriptorType != 0 else {
            logger.warning("Got empty result from AppleScript")
            return nil
        }

        guard result.numberOfItems >= 6 else {
            logger.warning("Result has insufficient item count: \(result.numberOfItems)")
            return nil
        }

        guard
            let playState = result.atIndex(1)?.stringValue,
            playState == "playing"
        else {
            return nil
        }

        let trackName = result.atIndex(2)?.stringValue ?? "Unknown track"
        let artistName = result.atIndex(3)?.stringValue ?? "Unknown artist"
        let albumName = result.atIndex(4)?.stringValue ?? "Unknown album"

        let durationSeconds = result.atIndex(5)?.doubleValue ?? -1
        let elapsedSeconds = result.atIndex(6)?.doubleValue ?? 0

        return MusicState(
            trackName: trackName,
            artistName: artistName,
            albumName: albumName,
            elapsedSeconds: elapsedSeconds,
            durationSeconds: durationSeconds,
            updatedAt: now
        )
    }
}
