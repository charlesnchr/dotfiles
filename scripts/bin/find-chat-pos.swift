import AppKit
import CoreGraphics

guard CommandLine.arguments.count >= 3 else {
    print("0 25")
    exit(1)
}

let chatW = Int(CommandLine.arguments[1]) ?? 580
let chatH = Int(CommandLine.arguments[2]) ?? 920

let screen = NSScreen.main!
let screenW = Int(screen.frame.width)
let screenH = Int(screen.frame.height)
let menuBar = 25

let frontPID = NSWorkspace.shared.frontmostApplication?.processIdentifier ?? 0

struct Rect { let x, y, w, h: Int; let isFront: Bool }

var windows: [Rect] = []
if let list = CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID) as? [[String: Any]] {
    for win in list {
        guard let bounds = win[kCGWindowBounds as String] as? [String: CGFloat],
              let layer = win[kCGWindowLayer as String] as? Int,
              layer == 0 else { continue }
        let x = Int(bounds["X"] ?? 0)
        let y = Int(bounds["Y"] ?? 0)
        let w = Int(bounds["Width"] ?? 0)
        let h = Int(bounds["Height"] ?? 0)
        if w < 80 || h < 80 { continue }
        let pid = win[kCGWindowOwnerPID as String] as? Int32 ?? 0
        windows.append(Rect(x: x, y: y, w: w, h: h, isFront: pid == frontPID))
    }
}

let step = 30
var bestX = (screenW - chatW) / 2
var bestY = (screenH - chatH) / 2
var bestScore = Double.infinity
let cx = Double(screenW) / 2.0
let cy = Double(screenH) / 2.0

for px in stride(from: 20, through: screenW - chatW - 20, by: step) {
    for py in stride(from: menuBar, through: screenH - chatH - 10, by: step) {
        var score = 0.0
        for w in windows {
            let ox = max(0, min(px + chatW, w.x + w.w) - max(px, w.x))
            let oy = max(0, min(py + chatH, w.y + w.h) - max(py, w.y))
            let overlap = Double(ox * oy)
            score += w.isFront ? overlap * 3.0 : overlap
        }
        let dx = (Double(px) + Double(chatW) / 2.0 - cx) / Double(screenW)
        let dy = (Double(py) + Double(chatH) / 2.0 - cy) / Double(screenH)
        score += (dx * dx + dy * dy) * 5000.0

        if score < bestScore {
            bestScore = score
            bestX = px
            bestY = py
        }
    }
}

print("\(bestX) \(bestY)")
