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

<img src="https://github.com/garynewby/PianoKeyboard/raw/master/screen.png" width="800">
<img src="https://github.com/garynewby/PianoKeyboard/raw/master/screen2.png" width="800">
<img src="https://github.com/garynewby/PianoKeyboard/raw/master/screen3.png" width="800">

## Installation

### Swift Package Manager

https://github.com/garynewby/PianoKeyboard.git

## Demo

The Example app demonstrates integrating PianoKeyboard in a SwiftUI project and creating a custom style, and includes a simple AVAudioEngine based sound source.

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

- Swift 5, SwiftUI

## Author

Gary Newby

## License

Licensed under the MIT License.

