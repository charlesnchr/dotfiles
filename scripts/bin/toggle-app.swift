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

if let app = running {
    if app.isActive {
        app.hide()
    } else {
        app.activate()
    }
} else {
    if !workspace.open(URL(fileURLWithPath: "/Applications/\(appName).app")) {
        let task = Process()
        task.launchPath = "/usr/bin/open"
        task.arguments = ["-a", appName]
        task.launch()
    }
}
