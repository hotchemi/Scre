import AVFoundation

enum PixelSize: Int, CaseIterable {
    case original
    case high
    case medium
    case low
    
    var preset: AVCaptureSession.Preset? {
        switch self {
        case .original:
            return nil
        case .high:
            return AVCaptureSession.Preset.high
        case .medium:
            return AVCaptureSession.Preset.medium
        case .low:
            return AVCaptureSession.Preset.low
        }
    }
    
    var label: String {
        switch self {
        case .original:
            return "Original"
        case .high:
            return "High"
        case .medium:
            return "Middle"
        case .low:
            return "Low"
        }
    }
}
