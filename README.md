PianoKeyboard
============
An iOS piano keyboard view for iPhone or iPad, written in Swift 5. 
Has an IBDesignable preview in interface builder with IBInspectable properties for:
- Number of keys
- Hide/show note names on white keys
- Black key height and width
- Hightlight keys, with individual colour (optional play note)
- Custom key labels

Other features
- Latch/Hold key

All images are drawn using Core Graphics.

## Example app

![alt tag](https://github.com/garynewby/PianoKeyboard/raw/master/screen.png)


## Installation

### CocoaPods
To use via CocoaPods, add the following line to your Podfile:

```
pod 'PianoKeyboard'
```

### Swift Package Manager
With Xcode 11+ you can add PianoKeyboard to your project using the Swift Package Manager. From the File menu select Swift Packages and then select Add Package Dependency. A dialogue then will request the package repository URL, enter:
```
https://github.com/garynewby/PianoKeyboard.git
```

## Demo

The Example app demonstrates how to integrate and use PianoKeyboard in your project. It includes a simple AVAudioEngine/AVAudioUnitSampler based sound source.


### Delegate Methods

```swift
func pianoKeyDown(_ keyNumber: Int) {
  // Called when the key corresponding to midi number keyNumber is pressed
}

func pianoKeyUp(_ keyNumber: Int) {
  // Called when the key corresponding to midi number keyNumber is released
}
```

### Key Labels

A key's label must be assigned a value for it to show:
```
keyboard.setLabel(for: 60, text: "Do")
keyboard.setLabel(for: 62, text: "Re")
keyboard.setLabel(for: 64, text: "Mi")

for noteNumber in 65...72 {
    keyboard.setLabel(for: noteNumber, text: Note.name(for: noteNumber))
}
```

### Requirements

- Swift 5

## Author

Gary Newby

## License

Licensed under the MIT License.

