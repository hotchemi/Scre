import Cocoa
import SwiftUI

extension NSWindow {
    func toggleMoving(enabled: Bool) {
        if enabled {
            styleMask.update(with: .resizable)
            isMovable = true
            isMovableByWindowBackground = true
            level = NSWindow.Level(Int(CGWindowLevelForKey(.normalWindow)))
        } else {
            styleMask.remove(.resizable)
            isMovable = false
            isMovableByWindowBackground = false
            level = NSWindow.Level(Int(CGWindowLevelForKey(.floatingWindow)))
        }
    }
    
    func setSizeAsTitle() {
        title = sizeAsTitle()
    }
    
    func sizeAsTitle() -> String {
        return "Size: \(frame.size.width.description) × \(frame.size.height.description)"
    }
}

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool) -> some View {
        if hidden {
            self.hidden()
        } else {
            self
        }
    }
}
