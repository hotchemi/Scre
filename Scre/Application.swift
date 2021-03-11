import SwiftUI

@main
struct Application: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        Settings {
            SettingsView()
        }
        .commands {
            // disable creating new window
            CommandGroup(replacing: CommandGroupPlacement.newItem) {
            }
        }
    }
}
