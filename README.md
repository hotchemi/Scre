# Scre

<p align="center">
<image  align="center" src="https://github.com/hotchemi/Scre/blob/master/images/icon.png" width="256">
</p>

A lightweight screen recorder macOS application written in SwiftUI.

## Demo

<p align="center">
<image src="https://github.com/hotchemi/Scre/blob/master/images/demo.gif">
</p>

## Install

You can use [homebrew-cask](https://github.com/Homebrew/homebrew-cask) or download from [release](https://github.com/hotchemi/Scre/releases) page.

```sh
brew tap hotchemi/tap
brew install scre
```

## Keyboard Shortcuts

- `Command + s`: record/stop button
- `Command + l`: Show other windows
- `Command + ,`: Settings

## Settings

- Always ask file path
  - if the option is false, we automatically save GIF file under `Movies` folder.
- Mouse button press
  - You can capture your mouse and its press event.
- Repeat
  - You can choose whether the GIF file supports repeat or not
- Pixel Size
  - Original, High, Middle, Low
- Frame Rate
  - High, Middle, Low

<p align="center">
<image src="https://github.com/hotchemi/Scre/blob/master/images/preference.png" width="480"
</p>

## Build

You need CocoaPods to resolve dependencies.

```sh
pod install
```

And open `Scre.xcworkspace` on XCode and here you go!