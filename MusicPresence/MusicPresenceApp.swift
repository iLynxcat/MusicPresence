import OSLog
import SwiftUI

@main
struct MusicPresenceApp: App {
    private let logger = createLogger("app")
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let presenceManager: RichPresenceManager
    let musicWatcher: MusicWatcher

    static var bundleId: String {
        Bundle.main.bundleIdentifier!
    }

    init() {
        logger.info("Starting app...")
        self.presenceManager = RichPresenceManager()
        self.musicWatcher = MusicWatcher(rpc: presenceManager)
        
        presenceManager.connect()
    }
    
    var body: some Scene {
        MenuBarView(presenceManager, musicWatcher)
    }
}
