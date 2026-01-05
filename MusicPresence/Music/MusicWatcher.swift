import Foundation

@Observable
class MusicWatcher {
    public private(set) var playState: MusicState?

    private var notificationListener: NSObjectProtocol?
    private var launchListener: NSObjectProtocol?

    init() {
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
    }

    func handleNotification(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }

        print(userInfo)

        guard userInfo["Player State"] as? String == "Playing" else {
            self.playState = nil
            return
        }

        if let track = userInfo["Name"] as? String,
            let album = userInfo["Album"] as? String,
            let artist = userInfo["Artist"] as? String,
            let duration = userInfo["Total Time"] as? String
        {
            self.playState = MusicState(
                trackName: track,
                artistName: artist,
                albumName: album,
                elapsedSeconds: 0,
                durationSeconds: try! TimeInterval(duration, format: .number)
            )
        }

        guard let polledData = poll() else {
            return
        }
        self.playState = polledData
    }
}

extension Notification.Name {
    static let playerInfo = Notification.Name("com.apple.Music.playerInfo")
}
