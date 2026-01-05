import Foundation

@Observable
class MusicWatcher {
    private let rpc: RichPresenceManager

    public private(set) var playState: MusicState?

    private var notificationListener: NSObjectProtocol?
    private var launchListener: NSObjectProtocol?

    init(rpc: RichPresenceManager) {
        self.rpc = rpc

        launchListener = NotificationCenter.default.addObserver(
            forName: .appDidLaunch,
            object: nil,
            queue: .main,
            using: self.poll
        )
        notificationListener = DistributedNotificationCenter.default()
            .addObserver(
                forName: .playerInfo,
                object: nil,
                queue: .main,
                using: self.handleNotification
            )
    }

    deinit {
        if let notificationListener {
            DistributedNotificationCenter.default()
                .removeObserver(notificationListener)
        }
        if let launchListener {
            NotificationCenter.default
                .removeObserver(launchListener)
        }
    }

    func poll(_: Notification) {
        print("Polling for launch!")

        playState = self.poll()
        rpc.updatePresence(playState)
    }

    func handleNotification(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard userInfo["Player State"] as? String == "Playing" else {
            self.playState = nil
            rpc.updatePresence(nil)
            return
        }

        guard let polledData = poll() else {
            return
        }

        self.playState = polledData
        rpc.updatePresence(playState)
    }
}

extension Notification.Name {
    static let playerInfo = Notification.Name("com.apple.Music.playerInfo")
}
