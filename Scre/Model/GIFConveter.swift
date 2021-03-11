import Foundation
import NSGIF

final class GIFConverter {
    typealias Completion = (URL?) -> Void
    private let config = Config.shared

    private var gifUrl: URL {
        if config.alwaysAskFilePath {
            return URL(fileURLWithPath: Config.shared.location)
        } else {
            let url = NSSearchPathForDirectoriesInDomains(.moviesDirectory, .userDomainMask, true).first ?? ""
            return URL(fileURLWithPath: url).appendingPathComponent(Utils.formatter.string(from: Date())).appendingPathExtension("gif")
        }
    }
    
    func save(videoUrl: URL, completion: @escaping Completion) {
        NSGIF.createGIFfromURL(videoUrl, withFrameCount: config.frameCount, delayTime: 0, loopCount: config.repeatAllowed){ [weak self] url in
            self?.copy(url: url, completion: completion)
        }
    }
    
    private func copy(url: URL?, completion: @escaping Completion) {
        guard let url = url else {
            completion(nil)
            return
        }
        defer {
            try? FileManager.default.removeItem(at: url)
        }
        do {
            let gifUrl = self.gifUrl
            try FileManager.default.copyItem(at: url, to: gifUrl)
            completion(gifUrl)
        } catch {
            completion(nil)
        }
    }
}
