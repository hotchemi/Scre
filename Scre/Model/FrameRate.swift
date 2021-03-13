import Foundation

enum FrameRate: Int, CaseIterable {
    case high
    case medium
    case low
    
    var frameRate: Int {
        switch self {
        case .high:
            return 30
        case .medium:
            return 15
        case .low:
            return 8
        }
    }
    
    var label: String {
        switch self {
        case .high:
            return "High(\(frameRate))"
        case .medium:
            return "Middle(\(frameRate))"
        case .low:
            return "Low(\(frameRate))"
        }
    }
}
