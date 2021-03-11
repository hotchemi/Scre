
import Foundation
import SwiftUI

final class PathControlDelegate: NSObject, ObservableObject, NSPathControlDelegate {
    var transformMenuItems: ([PathMenuItem]) -> [PathMenuItem] = { currentPathItems in
        var defaultItems = [
            PathMenuItem.fileChooser(),
            PathMenuItem(type: .divider, title: "")
        ]
        defaultItems.append(contentsOf: currentPathItems)
        return defaultItems
    }
    var urlChanged: (URL?) -> Void = { _ in }
    var actions = [ActionWrapper]()

    @objc func pathItemClicked(_ sender: NSPathControl) {
        urlChanged(sender.clickedPathItem?.url)
    }

    func pathControl(_ pathControl: NSPathControl, willPopUp menu: NSMenu) {
        actions = []

        let fileChooserItem = menu.item(at: 0)!
        let pathMenuItems: [NSMenuItem]
        if menu.items.count > 2 {
            pathMenuItems = (2..<menu.numberOfItems).compactMap { menu.item(at: $0) }
        } else {
            pathMenuItems = []
        }

        let originalPathItems = pathMenuItems.map {
            PathMenuItem(type: .wrapped($0), title: $0.title)
        }
        let menuDefinition = transformMenuItems(originalPathItems)
        menu.items = createMenu(from: menuDefinition, fileChooserItem: fileChooserItem)
    }

    private func createMenu(from definingMenuItems: [PathMenuItem], fileChooserItem: NSMenuItem) -> [NSMenuItem] {
        return definingMenuItems.map { item in
            switch item.type {
            case .divider:
                return .separator()

            case .fileChooser:
                return item.build(basedOn: fileChooserItem)

            case .wrapped(let wrappedMenuItem):
                return item.build(basedOn: wrappedMenuItem)

            case .item:
                let action = ActionWrapper(action: item.action)
                actions.append(action)

                let newItem = NSMenuItem(title: item.title, action: #selector(action.perform), keyEquivalent: "")
                newItem.target = action

                if !item.children.isEmpty {
                    let submenu = NSMenu(title: item.title)
                    submenu.items = createMenu(from: item.children, fileChooserItem: fileChooserItem)
                    newItem.submenu = submenu
                }
                return newItem
            }
        }
    }
}

extension PathMenuItem {
    func build(basedOn menuItem: NSMenuItem) -> NSMenuItem {
        let menuItemCopy = menuItem.copy() as! NSMenuItem
        menuItemCopy.title = title
        return menuItemCopy
    }
}

class ActionWrapper {
    let action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    @objc func perform() {
        action()
    }
}
