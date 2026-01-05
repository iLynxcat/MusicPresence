import OSLog
import SwiftUI

@main
struct MusicPresenceApp: App {
    private let logger = createLogger("app")

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var presenceManager = RichPresenceManager()
    var musicWatcher = MusicWatcher()

    static var bundleId: String {
        Bundle.main.bundleIdentifier!
    }

    init() {
        logger.info("Starting app...")
        presenceManager.connect()
    }

    var body: some Scene {
        MenuBarView(presenceManager, musicWatcher)
            .environment(musicWatcher)
            .onChange(of: musicWatcher.playState) { _, state in
                presenceManager.updatePresence(state)
            }
    }
}
