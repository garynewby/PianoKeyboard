GLNPianoView
============

A piano keyboard view, written in Swift 3.0. 
Has an IBInspectable key count property and IB_DESIGNABLE preview. 
All image elements are drawn using Core Graphics. 

![alt tag](https://github.com/garynewby/GLNPianoView/raw/master/screen.png)


## Installation

GLNPianoView is available through CocoaPods. To install it, simply add the following line to your Podfile:

```swift
pod 'GLNPianoView'
```

## Demo

The <i>Example</i> demo project demonstrates how to use and integrate the GLNPianoView into your project, using AVAudioEngine and an AVAudioUnitSampler as the sound source.

##Delegate Methods

```swift
func pianoKeyDown(keyNumber:Int) {
  // Called when the key corresponding to midi number keyNumber is pressed
}

func pianoKeyUp(keyNumber:Int) {
  // Called when the key corresponding to midi number keyNumber is released
}
```

##<a name="overview"></a>Requirements

- Requires iOS 8.0 or later
- Requires Automatic Reference Counting (ARC)

## Author

Gary Newby

## License

Licensed under the MIT License.

