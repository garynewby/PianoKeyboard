PianoKeyboard
============

[![Build and test](https://github.com/garynewby/PianoKeyboard/actions/workflows/build.yml/badge.svg?branch=master)](https://github.com/garynewby/PianoKeyboard/actions/workflows/build.yml)

A SwiftUI piano keyboard view for iPhone and iPad. 

Easily customisable styles, configurable
- Number of keys
- Note names
- Key metrics
- Latch, toggle key on/off
- See 'uikit' branch for older UIKit version 

## Example app

![alt tag](https://github.com/garynewby/PianoKeyboard/raw/master/screen.png)


## Installation

```

### Swift Package Manager

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

### Requirements

- Swift 5

## Author

Gary Newby

## License

Licensed under the MIT License.

