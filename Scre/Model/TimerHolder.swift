import SwiftUI
import Combine

class TimerHolder : ObservableObject {
    @Published var navigationTitle = ""
    private var timer : Timer?
    private var count = 0
    private var startDate: Date?
    
    func start() {
        timer?.invalidate()
        count = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
            self.count += 1
            self.navigationTitle = self.createTimeString(count)
        }
    }
    
    private func createTimeString(_ seconds: Int) -> String {
        let m = (seconds / 60) % 60
        let s  = seconds % 60
        return String(format: "%02u:%02u", m, s)
    }
    
    func stop() {
        timer?.invalidate()
        count = 0
    }
}
