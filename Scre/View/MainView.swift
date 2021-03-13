import SwiftUI

struct MainView: View {
    enum ViewState {
        case idle
        case start
        case recording
        case stop
        case finish
        case error
    }
    // TODO: move to ViewModel
    private let screenRecorder = ScreenRecorder()
    @AppStorage(Config.Key.location.rawValue) private var location = ""
    @AppStorage(Config.Key.alwaysAskFilePath.rawValue) private var alwaysAskFilePath = false

    @NSApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    @ObservedObject private var timerHolder = TimerHolder()
    @State private var recordButtonText = "play.fill"
    @State private var isActionButtonDisabled = false
    @State private var isProgressHidden = true
    @State private var showPopover = false
    @State private var showAlert = false
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
                    })
                    .keyboardShortcut("s", modifiers: [.command])
                    .disabled(isActionButtonDisabled)
                    Spacer()
                    Button(action: {
                        showPopover.toggle()
                    }, label: {
                        Image(systemName: "macwindow")
                    })
                    .keyboardShortcut("l", modifiers: [.command])
                    .popover(
                        isPresented: self.$showPopover,
                        arrowEdge: .bottom
                    ) {
                        // TODO: separate view
                        let windows = WindowServer.getWindows()
                        let apps = windows.map { NSRunningApplication(processIdentifier: pid_t($0.pid)) }
                        List {
                            ForEach(0 ..< windows.count, id: \.self) { index in
                                Button(action: {
                                    showPopover.toggle()
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
                                    Image(nsImage: (apps[index]?.icon)!)
                                    Text(apps[index]?.localizedName ?? "")
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                .padding(8)
                .background(Color(NSColor.windowBackgroundColor))
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"),
                          message: Text("Sorry, something wrong has happenned.")
                    )
                }
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
        case .idle:
            recordButtonText = "play.fill"
            delegate.window?.toggleMoving(enabled: true)
            isProgressHidden = true
            timerHolder.navigationTitle = delegate.window?.sizeAsTitle() ?? ""
            isActionButtonDisabled = false
        case .start:
            let closure = {
                screenRecorder.delegate = self
                screenRecorder.record(rect: Utils.recordFrame(window: delegate.window))
                recordButtonText = "stop.fill"
                isProgressHidden = true
                delegate.window?.toggleMoving(enabled: false)
                timerHolder.navigationTitle = "Record will start..."
                isActionButtonDisabled = true
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
            isActionButtonDisabled = false
        case .stop:
            screenRecorder.stop()
            isProgressHidden = false
            timerHolder.navigationTitle = "Converting to GIF..."
            timerHolder.stop()
            isActionButtonDisabled = true
        case .finish:
            state = .idle
            isProgressHidden = false
            isActionButtonDisabled = false
        case .error:
            state = .idle
            showAlert = true
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
