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
    
    func setInitialFrame(prevRect: CGRect) {
        if prevRect == .zero, let screenSize = screen?.visibleFrame.size {
            let width: CGFloat = 400
            let height: CGFloat = 600
            let x = (screenSize.width - prevRect.size.width) / 2 - (width / 2)
            let y = (screenSize.height - prevRect.size.height) / 2 - (height / 2)
            setFrame(CGRect(x: x, y: y, width: width, height: height), display: true)
        } else {
            setFrame(frame, display: true)
        }
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
