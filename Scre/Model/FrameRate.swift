import Foundation

enum FrameRate: Int, CaseIterable {
    case high
    case medium
    case low
    
    var frameCount: Int32 {
        switch self {
        case .high:
            return 90
        case .medium:
            return 60
        case .low:
            return 30
        }
    }
    
    var label: String {
        switch self {
        case .high:
            return "High"
        case .medium:
            return "Middle"
        case .low:
            return "Low"
        }
    }
}
