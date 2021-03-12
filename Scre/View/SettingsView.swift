import SwiftUI

struct SettingsView: View {
    var body: some View {
        GeneralSettingsView()
    }
}

struct GeneralSettingsView: View {
    // TODO: move to ViewModel
    @AppStorage(Config.Key.alwaysAskFilePath.rawValue) private var alwaysAskFilePath = false
    @AppStorage(Config.Key.mouseButtonPress.rawValue) private var mouseButtonPress = true
    @AppStorage(Config.Key.repeatAllowed.rawValue) private var repeatAllowed = true
    @AppStorage(Config.Key.pixelSize.rawValue) private var pixelSize = PixelSize.original.rawValue
    @AppStorage(Config.Key.frameRate.rawValue) private var frameRate = FrameRate.high.rawValue
    @AppStorage(Config.Key.location.rawValue) private var location = ""
    
    var body: some View {
        Form {
            Toggle("Always ask file path", isOn: $alwaysAskFilePath)
                .toggleStyle(SwitchToggleStyle())
            Toggle("Mouse button press", isOn: $mouseButtonPress)
                .toggleStyle(SwitchToggleStyle())
            Toggle("Repeat", isOn: $repeatAllowed)
                .toggleStyle(SwitchToggleStyle())
            Picker(selection: $pixelSize, label: Text("Pixel Size")) {
                ForEach(PixelSize.allCases, id: \.self) { size in
                    Text(size.label).tag(size.rawValue)
                }
            }
            .frame(width: 150)
            Picker(selection: $frameRate, label: Text("Frame Rate")) {
                ForEach(FrameRate.allCases, id: \.self) {rate in
                    Text(rate.label).tag(rate.rawValue)
                }
            }
            .frame(width: 150)
        }
        .frame(width: 350)
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
