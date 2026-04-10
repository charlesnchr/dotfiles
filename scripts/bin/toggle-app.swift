import AppKit

guard CommandLine.arguments.count > 1 else { exit(1) }
let appName = CommandLine.arguments[1]

let workspace = NSWorkspace.shared
let running = workspace.runningApplications.first {
    guard let name = $0.localizedName else { return false }
    let clean = name.replacingOccurrences(of: "\u{200E}", with: "")
        .replacingOccurrences(of: "\u{200F}", with: "")
        .trimmingCharacters(in: .whitespaces)
    return clean == appName
}

func openApp() {
    if !workspace.open(URL(fileURLWithPath: "/Applications/\(appName).app")) {
        let task = Process()
        task.launchPath = "/usr/bin/open"
        task.arguments = ["-a", appName]
        task.launch()
    }
}

if let app = running {
    if app.isActive {
        app.hide()
    } else {
        // Check if the app has any on-screen windows; if not, re-open it
        // so it creates a new window instead of just activating an empty dock icon.
        let appWindows = CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID) as? [[String: Any]] ?? []
        let hasWindows = appWindows.contains { ($0[kCGWindowOwnerPID as String] as? Int32) == app.processIdentifier }
        if hasWindows {
            app.activate()
        } else {
            openApp()
        }
    }
} else {
    openApp()
}
