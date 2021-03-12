import Cocoa

struct Utils {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH.mm.ss"
        return formatter
    }()
    
    static func recordFrame(window: NSWindow?) -> CGRect {
        guard let window = window else {
            return CGRect.zero
        }
        let lineWidth: CGFloat = 2
        let titleHeight: CGFloat = 12
        let someValue: CGFloat = 20
        return CGRect(x: window.frame.origin.x + lineWidth,
                      y: window.frame.origin.y + titleHeight + someValue + lineWidth,
                      width: window.frame.size.width - lineWidth * 2,
                      height: window.frame.size.height - 40 - someValue - lineWidth)
    }
}
