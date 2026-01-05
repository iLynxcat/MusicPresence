import OSLog

func createLogger(_ category: String) -> Logger {
    return Logger(subsystem: MusicPresenceApp.bundleId, category: category)
}
