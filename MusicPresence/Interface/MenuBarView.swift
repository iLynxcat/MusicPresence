import OSLog
import SwiftUI

let MENU_BAR_INSERTED_KEY = "showMenuBarItem"

struct MenuBarView: Scene {
    private let logger = createLogger("MenuBarView")

    /// Bundle identifier used to trigger activation of the Music app.
    private static let MUSIC_BUNDLE_ID = "com.apple.Music"

    @AppStorage(MENU_BAR_INSERTED_KEY) private var isInserted = true

    @Environment(\.scenePhase) var scenePhase

    private let rpc: RichPresenceManager
    private let music: MusicWatcher

    init(_ rpc: RichPresenceManager, _ music: MusicWatcher) {
        self.rpc = rpc
        self.music = music
    }

    var body: some Scene {
        MenuBarExtra(
            "Music Presence",
            systemImage: "music.note",
            isInserted: $isInserted
        ) {
            Button("Open Music app") {
                activateMusicApp()
            }

            Divider()

            Group {
                if let state = music.playState {
                    Button(state.trackName, systemImage: "music.note") {}
                    Button(state.artistName, systemImage: "music.microphone") {}
                    Button(
                        state.albumName,
                        systemImage: "music.note.square.stack"
                    ) {}
                } else {
                    Button("–", systemImage: "music.note") {}
                    Button("–", systemImage: "music.microphone") {}
                    Button("–", systemImage: "music.note.square.stack") {}
                }
            }
            .disabled(true)

            Divider()

            Group {
                Button("Refresh", systemImage: "arrow.clockwise") {
                    rpc.updatePresence(music.poll())
                }
                .keyboardShortcut(
                    KeyboardShortcut(.init("r"), modifiers: .command)
                )

                Button("Quit", systemImage: "xmark.rectangle") {
                    NSApp.terminate(nil)
                }
                .keyboardShortcut(
                    KeyboardShortcut(.init("q"), modifiers: .command)
                )
            }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            // re-show menu bar icon when user relaunches app while open
            if newPhase == .active {
                isInserted = true
            }
        }
    }

    func activateMusicApp() {
        let workspace = NSWorkspace.shared

        if let musicURL = workspace.urlForApplication(
            withBundleIdentifier: Self.MUSIC_BUNDLE_ID
        ) {
            let configuration = NSWorkspace.OpenConfiguration()
            configuration.activates = true

            // TODO: open the current track in Music

            workspace.openApplication(
                at: musicURL,
                configuration: configuration
            )
        } else {
            logger.warning(
                "App with bundle identifier '\(Self.MUSIC_BUNDLE_ID)' not found."
            )
        }
    }
}
