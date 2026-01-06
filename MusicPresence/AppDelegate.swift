import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NotificationCenter.default.post(name: .appDidLaunch, object: nil)
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows: Bool) -> Bool {
        // restore menu bar icon on relaunch
        UserDefaults.standard.set(true, forKey: MENU_BAR_INSERTED_KEY)
        return true
    }
}

extension Notification.Name {
    static let appDidLaunch = Notification.Name("appDidLaunch")
}
