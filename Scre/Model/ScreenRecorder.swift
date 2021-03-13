import AVFoundation
import Cocoa

protocol ScreenRecorderDelegate {
    func screenRecorder(recorder: ScreenRecorder, didStateChange state: MainView.ViewState)
}

final class ScreenRecorder: NSObject {
    private let input = AVCaptureScreenInput(displayID: CGMainDisplayID())
    private let output = AVCaptureMovieFileOutput()
    private let session = AVCaptureSession()
    private let gifConveter = GIFConverter()
    private let config = Config.shared

    var delegate: ScreenRecorderDelegate?

    override init() {}

    func record(rect: CGRect) {
        guard let input = input else {
            debugPrint("failed to initialize AVCaptureScreenInput")
            return
        }
        if let preset = config.sessionPreset {
            session.sessionPreset = preset
        } else {
            input.scaleFactor = 0.505
        }
        input.cropRect = rect
        input.capturesCursor = config.mouseButtonPress
        input.capturesMouseClicks = config.mouseButtonPress
        if session.canAddInput(input) {
            session.addInput(input)
        }
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        let tempVideoUrl = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("mov")
        session.startRunning()
        output.startRecording(to: tempVideoUrl, recordingDelegate: self)
    }
    
    func stop() {
        output.stopRecording()
        session.stopRunning()
        session.removeOutput(output)
        if let input = input {
            session.removeInput(input)
        }
    }
}

// MARK: - AVCaptureFileOutputRecordingDelegate
extension ScreenRecorder: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        delegate?.screenRecorder(recorder: self, didStateChange: .recording)
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        delegate?.screenRecorder(recorder: self, didStateChange: .stop)
        let duration = CMTimeGetSeconds(output.recordedDuration)
        gifConveter.save(videoUrl: outputFileURL, duration: Float(duration)) { [weak self] url in
            guard let self = self else {
                return
            }
            self.delegate?.screenRecorder(recorder: self, didStateChange: .finish(url))
        }
    }
}
