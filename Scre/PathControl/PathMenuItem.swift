import Foundation
import SwiftUI

/// An item which can be displayed inside of path control.
public struct PathMenuItem {
    /// The title of menu item.
    public let title: String

    /// Creates a path menu item with the given title.
    ///
    /// - Parameter title: The title of menu item.
    public init(title: String, action: @escaping () -> Void) {
        self.init(type: .item, title: title, action: action)
    }

    enum MenuItemType: Equatable {
        case fileChooser
        case divider
        case wrapped(NSMenuItem)
        case item
    }

    let type: MenuItemType
    let action: () -> Void
    let children: [PathMenuItem]

    init(type: MenuItemType, title: String, action: @escaping () -> Void = {}, children: [PathMenuItem] = []) {
        self.type = type
        self.title = title
        self.action = action
        self.children = children
    }
}

extension PathMenuItem {

    /// Creates a path menu item which opens a file chooser panel.
    ///
    /// - Parameter title: Title of created menu item.  Defaults to "Choose…".
    public static func fileChooser(title: String = "Choose…") -> PathMenuItem {
        PathMenuItem(type: .fileChooser, title: title)
    }
}
