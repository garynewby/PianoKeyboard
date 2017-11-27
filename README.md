GLNPianoView
============
An iOS piano keyboard view, written in Swift 4.0. 
Has an IBDesignable preview in interface builder with IBInspectable properties for:
- Number of keys
- Hide/show note names on keys
- Black key height and width
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

### Requirements

- iOS 8.0+
- Swift 4.0+

## Author

Gary Newby

## License

Licensed under the MIT License.

