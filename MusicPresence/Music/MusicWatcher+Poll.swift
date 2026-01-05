import AppKit
import Foundation

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
        var error: NSDictionary?
        let result = pollScript.executeAndReturnError(&error)

        if let error {
            print("AppleScript error: \(error)")

            if let errorNumber = error["NSAppleScriptErrorNumber"] as? Int {
                print("Error number: \(errorNumber)")

                if errorNumber == -1743 || errorNumber == -1744 {
                    print("No automation permission for Music!")
                }
            }
            return nil
        }

        guard result.descriptorType != 0 else {
            print("Got empty result from AppleScript")
            return nil
        }

        guard result.numberOfItems >= 6 else {
            print("Result has insufficient items: \(result.numberOfItems)")
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
            durationSeconds: durationSeconds
        )
    }
}
