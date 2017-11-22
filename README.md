GLNPianoView
============

A piano keyboard view, written in Swift 4.0. 
Has an IBInspectable key count and show notes properties, and IB_DESIGNABLE preview. 
All image elements are drawn using Core Graphics. 

![alt tag](https://github.com/garynewby/GLNPianoView/raw/master/screen.png)


## Installation

GLNPianoView is available through CocoaPods. To install it, simply add the following line to your Podfile:

```swift
pod 'GLNPianoView'
```

## Demo

The <i>Example</i> demo project demonstrates how to use and integrate the GLNPianoView into your project, using AVAudioEngine and an AVAudioUnitSampler as the sound source.


### Delegate Methods

```swift
func pianoKeyDown(_ keyNumber: UInt8) {
  // Called when the key corresponding to midi number keyNumber is pressed
}

func pianoKeyUp(_ keyNumber: UInt8) {
  // Called when the key corresponding to midi number keyNumber is released
}
```

### Data Source Methods

If you want to set a non-conventional arrangement of keys in your piano view you can do it with the data source. Data source is optional, if not implemented then the view takes the default values.

Set the number of keys per octave. (Default value: 12).

```swift
let keysPerOctave = 13 // Setting a crazy piano with 13 keys per octave!!!


func numberOfKeysPerOctaveInPiano(_ piano: GLNPianoView) -> Int {
  return keysPerOctave
}
```

Set what keys are white in your new non-convetional arrangement. (Default value: look at the private method `GLNPianoView.isWhiteKey(_:)`).

```swift
func piano(_ piano: GLNPianoView, isWhiteKey key: Int) -> Bool {
  let k = key % keysPerOctave
  return (k == 0 || k == 2 || k == 4 || k == 5 || k == 7 || k == 9 || k == 11 || k == 12)
}
```

Set what keys display their name. (Default value: the same as `GLNPianoView.showNotes`).

```swift
func piano(_ piano: GLNPianoView, shouldShowTextForKey key: Int) -> Bool {
  return key == 0 || key % keysPerOctave == 0
}
```

Set a custom name for each key. (Default value: look at the private method `GLNPianoView.textForNote(_:)`)

```swift
func piano(_ piano: GLNPianoView, textForKey key: Int) -> String {
  return "C\(2 + key / keysPerOctave)"
}
```

### Requirements

- iOS 8.0+
- Swift 4.0+

## Author

Gary Newby

## Collaborators

Francisco Bernal

## License

Licensed under the MIT License.

