import Foundation
import OSLog
import SwordRPC

private let DISCORD_APP_ID = "1340139884291162143"

class RichPresenceManager {
    let logger = createLogger("RPC Manager")

    let rpc: SwordRPC
    public internal(set) var isConnected: Bool = false

    init() {
        self.rpc = SwordRPC(appId: DISCORD_APP_ID)
        rpc.delegate = self
    }

    /// Connect to Discord and begin broadcasting player status.
    func connect() {
        logger.debug("Initializing Discord connection...")
        rpc.connect()
    }


    func updatePresence(_ state: MusicState?) {
        if !isConnected {
            logger.warning(
                "updatePresence() called while disconnected from Discord! Attempting update anyway"
            )
        }

        guard let state else {
            // set empty presence when not playing
            rpc.clearPresence()
            return
        }

        logger.debug("Updating presence...")
        logger.debug("\(["state":state])")

        var presence = RichPresence()
        presence.statusDisplayType = .state
        presence.type = .listening

        presence.state = state.artistName
        presence.details = state.trackName

        presence.timestamps.start =
            .now - state.elapsedSeconds
        presence.timestamps.end =
            .now + (state.durationSeconds - state.elapsedSeconds)

        presence.assets.largeText = state.albumName
        //        presence.assets.largeImage = "apple_music"  // album art (url?)

        //        presence.assets.smallImage = "apple_music"
        //        presence.assets.smallText = "Apple Music"

        rpc.setPresence(presence)
        logger.info("Presence updated")
    }
}
