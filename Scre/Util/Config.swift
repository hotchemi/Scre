import Foundation
import AVFoundation

struct Config {
    enum Key: String {
        case alwaysAskFilePath
        case mouseButtonPress
        case repeatAllowed
        case pixelSize
        case frameRate
        case location
        case windowFrame
    }
    
    static let shared = Config()
    let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    var location: String {
        userDefaults.string(forKey: Key.location.rawValue) ?? NSSearchPathForDirectoriesInDomains(.moviesDirectory, .userDomainMask, true).first ?? ""
    }
    
    var alwaysAskFilePath: Bool {
        userDefaults.bool(forKey: Key.alwaysAskFilePath.rawValue)
    }
    
    var mouseButtonPress: Bool {
        userDefaults.bool(forKey: Key.mouseButtonPress.rawValue)
    }
    
    var repeatAllowed: Int32 {
        userDefaults.bool(forKey: Key.repeatAllowed.rawValue) ? 0 : 1
    }
    
    var sessionPreset: AVCaptureSession.Preset? {
        PixelSize(rawValue: userDefaults.integer(forKey: Key.pixelSize.rawValue))?.preset
    }
    
    var frameCount: Int32 {
        FrameRate(rawValue: userDefaults.integer(forKey: Key.frameRate.rawValue))?.frameCount ?? FrameRate.high.frameCount
    }
}
