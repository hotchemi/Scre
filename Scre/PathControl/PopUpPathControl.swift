import SwiftUI

public struct PopUpPathControl: NSViewRepresentable {
    @ObservedObject private var delegate = PathControlDelegate()
    @Binding private var url: String

    public init(url: Binding<String>, @PathMenuBuilder content: @escaping ([PathMenuItem]) -> [PathMenuItem]) {
        self._url = url
        self.delegate.transformMenuItems = content
    }

    public init(url: Binding<String>) {
        self._url = url
    }

    public func makeNSView(context: Context) -> NSPathControl {
        let pathControl = NSPathControl()
        pathControl.pathStyle = .popUp
        pathControl.allowedTypes = ["public.folder"]
        pathControl.url = URL(fileURLWithPath: url)
        delegate.urlChanged = { newUrl in
            self.url = newUrl?.path ?? NSHomeDirectory().appending("/Downloads")
        }
        pathControl.target = delegate
        pathControl.action = #selector(delegate.pathItemClicked)
        pathControl.delegate = delegate
        return pathControl
    }

    public func updateNSView(_ nsView: NSPathControl, context: Context) {
        nsView.url = URL(fileURLWithPath: url)
    }
}
