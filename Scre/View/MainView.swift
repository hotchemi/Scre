import SwiftUI

struct MainView: View {
    enum ViewState {
        case start
        case recording
        case stop
        case finish(URL?)
        case idle
    }
    private let screenRecorder = ScreenRecorder()
    @AppStorage(Config.Key.location.rawValue) private var location = ""
    @AppStorage(Config.Key.alwaysAskFilePath.rawValue) private var alwaysAskFilePath = false

    @NSApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    @ObservedObject private var timerHolder = TimerHolder()
    @State private var recordButtonText = "play.fill"
    @State private var isProgressHidden = true
    @State private var showPopover: Bool = false
    @State var state: ViewState = .idle {
        didSet {
            DispatchQueue.main.async {
                self.handleStateChanged()
            }
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
                    }, label: {
                        Image(systemName: "gear")
                    })
                    Spacer()
                    Button(action: {
                        switch state {
                        case .idle:
                            state = .start
                        case .start, .recording:
                            state = .stop
                        default:
                            break
                        }
                    }, label: {
                        Image(systemName: recordButtonText)
                    }).keyboardShortcut("s", modifiers: [.command])
                    Spacer()
                    Button(action: {
                        showPopover = true
                    }, label: {
                        Image(systemName: "macwindow")
                    })
                    .keyboardShortcut("l", modifiers: [.command])
                    .popover(
                        isPresented: self.$showPopover,
                        arrowEdge: .bottom
                    ) {
                        let windows = WindowManager.getWindows()
                        let apps = windows.map { NSRunningApplication(processIdentifier: pid_t($0.pid)) }
                        List {
                            ForEach(0 ..< windows.count) { index in
                                Button(action: {
                                    showPopover = false
                                    guard let screen = NSScreen.main?.frame else {
                                        return
                                    }
                                    let width = windows[index].width
                                    let height = windows[index].height
                                    let x = windows[index].x
                                    let y = Int(screen.size.height) - windows[index].y - height
                                    let rect = CGRect(x: x, y: y, width: width, height: height)
                                    delegate.window?.setFrame(rect, display: true, animate: true)
                                }) {
                                    HStack {
                                        Image(nsImage: (apps[index]?.icon)!)
                                        Text(apps[index]?.localizedName ?? "")
                                    }
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                .padding(8)
                .background(Color(NSColor.windowBackgroundColor))
            }
            ProgressView().isHidden(isProgressHidden)
        }.navigationTitle(timerHolder.navigationTitle)
    }
    
    private func openSavePanel(successHandler: @escaping () -> Void, errorHandler: @escaping () -> Void) {
        let panel = NSSavePanel()
        panel.nameFieldStringValue = "\(Utils.formatter.string(from: Date())).gif"
        panel.showsTagField = true
        panel.canCreateDirectories = true
        panel.allowedFileTypes = ["gif"]
        panel.begin { response in
            if response == .OK, let url = panel.url {
                location = url.path
                successHandler()
            } else {
                errorHandler()
            }
        }
    }
    
    private func handleStateChanged() {
        switch state {
        case .start:
            let closure = {
                screenRecorder.delegate = self
                screenRecorder.record(rect: Utils.recordFrame(window: delegate.window))
                recordButtonText = "stop.fill"
                isProgressHidden = true
                delegate.window?.toggleMoving(enabled: false)
                timerHolder.navigationTitle = "Record will start..."
            }
            if alwaysAskFilePath {
                openSavePanel(successHandler: closure) {
                    state = .idle
                }
            } else {
                closure()
            }
        case .recording:
            recordButtonText = "stop.fill"
            isProgressHidden = true
            timerHolder.start()
        case .stop:
            screenRecorder.stop()
            isProgressHidden = false
            timerHolder.navigationTitle = "Converting to GIF..."
            timerHolder.stop()
        case .finish(_):
            state = .idle
            isProgressHidden = false
        case .idle:
            recordButtonText = "play.fill"
            delegate.window?.toggleMoving(enabled: true)
            isProgressHidden = true
            timerHolder.navigationTitle = delegate.window?.sizeAsTitle() ?? ""
        }
    }
}

extension MainView: ScreenRecorderDelegate {
    func screenRecorder(recorder: ScreenRecorder, didStateChange state: ViewState) {
        self.state = state
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
