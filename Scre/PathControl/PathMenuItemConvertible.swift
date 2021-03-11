import SwiftUI

/// Represents an object which can be converted into a path menu item.
public protocol PathMenuItemConvertible {
    /// Converts current object into a list of path menu items.
    func asMenuItems() -> [PathMenuItem]
}

extension PathMenuItem: PathMenuItemConvertible {
    public func asMenuItems() -> [PathMenuItem] {
        [self]
    }
}

extension Divider: PathMenuItemConvertible {
    public func asMenuItems() -> [PathMenuItem] {
        [PathMenuItem(type: .divider, title: "")]
    }
}

extension Array: PathMenuItemConvertible where Element: PathMenuItemConvertible {
    public func asMenuItems() -> [PathMenuItem] {
        return flatMap { $0.asMenuItems() }
    }
}
