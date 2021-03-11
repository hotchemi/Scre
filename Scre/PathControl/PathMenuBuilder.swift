import SwiftUI

/// A function builder used to build a path control menu.
@_functionBuilder
public struct PathMenuBuilder {
    public static func buildExpression(_ menuItem: PathMenuItemConvertible) -> [PathMenuItem] {
        return menuItem.asMenuItems()
    }

    public static func buildExpression(_ menuItem: PathMenuItemConvertible?) -> [PathMenuItem] {
        return menuItem?.asMenuItems() ?? []
    }

    public static func buildBlock(_ items: [PathMenuItem]...) -> [PathMenuItem] {
        return items.flatMap { $0 }
    }

    public static func buildDo(_ components: [PathMenuItem]...) -> [PathMenuItem] {
        return components.flatMap { $0 }
    }

    public static func buildOptional(_ component: [PathMenuItem]?) -> [PathMenuItem] {
        return component ?? []
    }

    public static func buildEither(first: [PathMenuItem]) -> [PathMenuItem] {
        return first
    }

    public static func buildEither(second: [PathMenuItem]) -> [PathMenuItem] {
        return second
    }

    public static func buildArray(_ components: [[PathMenuItem]]) -> [PathMenuItem] {
        return components.flatMap { $0 }
    }
}
