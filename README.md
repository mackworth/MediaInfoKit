# MediaInfoKit for OS X

## Introduction

MediaInfoKit is a very simple high leveled wrapper of MediaInfo library for OSX applications.

The frameworks was compiled and tested with Xcode 7 on El capitan and is fully compatible with Objective-C 2.0 and Swift 2.0. The project required OS X 10.8 and used ARC and Cocoa

The repository is composed of MediaInfoKit and of two samples (one written in Objective-C and the other one in Swift).

## How to use it

The frameworks is based on only one class named `MIKMediaInfo`. This class allow you to access to the metadatas in constant time via dictionary and it also permits you to get the original ordered list of metadata created by mediainfolib.

Objective-C code example :

```

```

Swift code example:

```

```

## Installation

You can add MediaInfoKit as a git submodule, drag the MediaInfoKit.xcodeproj file into your Xcode project, and add MediaInfoKit.xcodeproj as a dependency for your target.

## About

My name is Jeremy Vizzini and you can read more about me on [jeremyvizzini.com](http://jeremyvizzini.com). On this website I also try to write some articles about mathematics and computer science.

## References

* The MediaInfo library sources are maintened at [https://github.com/MediaArea/MediaInfo](https://github.com/MediaArea/MediaInfo).
* The original dylib is downloadable at [https://mediaarea.net/fr/MediaInfo/Download/Mac_OS](https://mediaarea.net/fr/MediaInfo/Download/Mac_OS)

## License

MediaInfoKit is released under a MIT license. See the LICENSE file for more information
