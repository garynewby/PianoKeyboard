GLNPianoView
============

A piano keyboard view, written in Swift. Has an IBInspectable key count property and IB_DESIGNABLE preview. All image elements drawn via Core Graphics. 

![alt tag](https://github.com/garynewby/GLNPianoView/raw/master/screen.png)


## Installation

GLNPianoView is available through CocoaPods. To install it, simply add the following line to your Podfile:

```swift
pod 'GLNPianoView'
```

## Demo

The <i>Example</i> project demonstrates how to use and integrate the GLNPianoView into your project.

##Delegate Methods

```swift
func pianoKeyDown(keyNumber:Int) {
  // Called a key corresponding to midi number keyNumber is pressed
}

func pianoKeyUp(keyNumber:Int) {
  // Called a key corresponding to midi number keyNumber is released
}
```

##<a name="overview"></a>Requirements

- Requires iOS 7.0 or later
- Requires Automatic Reference Counting (ARC)

## Author

Gary Newby

## License

Licensed under the MIT License.

