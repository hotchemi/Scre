import Foundation

struct WindowManager {
    struct Window {
        let pid: Int
        let x: Int
        let y: Int
        let width: Int
        let height: Int
    }
    
    static func getWindows() -> [Window] {
        var windows: [Window] = []
        let options = CGWindowListOption(arrayLiteral: .excludeDesktopElements, .optionOnScreenOnly)
        guard let windowList: NSArray = CGWindowListCopyWindowInfo(options, kCGNullWindowID) else {
            return windows
        }
        for window in windowList {
            let dict = window as! NSDictionary
            if ((dict.value(forKey: "kCGWindowAlpha") as! Double) == 0) {
                continue
            }
            var ownerName = ""
            if (dict.value(forKey: "kCGWindowOwnerName") != nil) {
                ownerName = dict.value(forKey: "kCGWindowOwnerName") as! String
            }
            let bundleName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
            if (bundleName == ownerName) {
                continue
            }
            let bounds = dict.value(forKey: "kCGWindowBounds") as! NSDictionary
            let x = bounds.value(forKey: "X")! as! Int
            let y = bounds.value(forKey: "Y")! as! Int
            let width = bounds.value(forKey: "Width")! as! Int
            let height = bounds.value(forKey: "Height")! as! Int
            let pid = dict.value(forKey: "kCGWindowOwnerPID") as! Int
            windows.append(Window(pid: pid, x: x, y: y, width: width, height: height))
        }
        return windows
    }
}
