#  Image Vision & VoiceOver

Created by Alan Chu [@ualch9](https://github.com/ualch9)

**This project requires Xcode 9 & iOS 11** - [More about CoreML and Vision on IOS](https://developer.apple.com/machine-learning/)

Last tested on iOS 11 beta 1

## Project Structure
`ImageVision.framework` - A standard wrapper framework for using ImageVision as well as VoiceOver string builders

**This project is not localized! It only supports English (US).**

## How to use framework
1. Import `ImageVision.framework` or `ImageVision.xcodeproj` to your existing *Xcode 9* project
* If using `framework`, ensure `ImageVision.framework` is attached to your build target
* If using `xcodeproj`, ensure a build scheme was created for `ImageVision.xcodeproj` as a `framework`

2. Import the framework to your source file using `import ImageVision`

These methods are compatible with using `Grand Central Dispatch`

**Accessing Files**: Accessing iCloud files may require you to add the iCloud Document entitlement to your target. Not doing so may cause this app to output an App Sandbox failure.

## Licenses
### `ImageVision.framework`
MIT License

Copyright (c) 2017 Alan Chu on behalf of Aeta.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
