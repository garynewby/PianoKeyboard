GLNPianoView
============
An iOS piano keyboard view for iPhone or iPad, written in Swift 5. 
Has an IBDesignable preview in interface builder with IBInspectable properties for:
- Number of keys
- Hide/show note names on white keys
- Black key height and width
- Hightlight keys, individual colour (play note)
- Custom key labels

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

- Swift 5

## Author

Gary Newby

## License

Licensed under the MIT License.

