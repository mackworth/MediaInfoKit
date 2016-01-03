# MediaInfoKit for OS X

## Introduction

MediaInfoKit is a very simple high level wrapper of MediaInfo library for OSX applications.

The frameworks was compiled and tested with Xcode 7 on El capitan and is fully compatible with Objective-C 2.0 and Swift 2.0. The project required OS X 10.8 and used ARC and Cocoa

The repository is composed of MediaInfoKit and of two samples (one written in Objective-C and the other one in Swift).

## What is MediaInfo?

**MediaInfo** is a convenient unified display of the most relevant technical and tag data for video and audio files.

#### The MediaInfo data display includes:

* Container: format, profile, commercial name of the format, duration, overall bit rate, writing application and library, title, author, director, album, track number, date, duration...
* Video: format, codec id, aspect, frame rate, bit rate, color space, chroma subsampling, bit depth, scan type, scan order...
* Audio: format, codec id, sample rate, channels, bit depth, language, bit rate...
* Text: format, codec id, language of subtitle...
* Chapters: count of chapters, list of chapters...

##### The MediaInfo data display includes:

* Container: MPEG-4, QuickTime, Matroska, AVI, MPEG-PS (including unprotected DVD), MPEG-TS (including unprotected Blu-ray), MXF, GXF, LXF, WMV, FLV, Real...
* Tags: Id3v1, Id3v2, Vorbis comments, APE tags...
* Video: MPEG-1/2 Video, H.263, MPEG-4 Visual (including DivX, XviD), H.264/AVC, Dirac...
* Audio: MPEG Audio (including MP3), AC3, DTS, AAC, Dolby E, AES3, FLAC...
* Subtitles: CEA-608, CEA-708, DTVCC, SCTE-20, SCTE-128, ATSC/53, CDP, DVB Subtitle, Teletext, SRT, SSA, ASS, SAMI...

## How to use it

The frameworks is based on only one class named `MIKMediaInfo`. This class allow you to access to the metadatas in constant time via dictionary and it also permits you to get the original ordered list of metadata created by mediainfolib.

Swift code example: (Objective-C version is similar)

```
// Create a MIKMediaInfo instance for a specified file

let bundle = NSBundle.mainBundle()
guard let movieURL = bundle.URLForResource("movie", withExtension: "mov") else {
    fatalError("The movie cannot be found.")
}

guard let info = MIKMediaInfo(fileURL: movieURL) else {
    fatalError("The movie is not readable by mediainfolib.")
}


// Get a single value for a key in constant time

let value = info.valueForKey(MIKCompleteNameKey, streamKey: MIKGeneralStreamKey)


// Get a single value at an index in constant time

let value = valueAtIndex(2, streamKey: MIKGeneralStreamKey)


// Enumerate all values by keeping the original order

info.enumerateOrderedValuesForStreamKey(MIKVideoStreamKey) { key, value in
    print("\(key) : \(value)")
}


// Export all information with the specified format

let exportExt = MIKMediaInfo.extensionForFormat(.JSON)
let exportURL = movieURL.URLByAppendingPathExtension(exportExt)

if info.writeAsFormat(.JSON,  toURL: exportURL) {
    print("File was written successfully").
}

```

## Installation

You can simply add MediaInfoKit as a git submodule and just drag the MediaInfoKit.xcodeproj file into your Xcode project and add MediaInfoKit.xcodeproj as a dependency for your target.    
Xcode 7 won't compile MediaInfoKit as it. To successfully compile, you have to sign MediaInfoKit with an apple developer account.

![How to sign framework](./images/how_to_sign_framework.png)

## About

My name is Jeremy Vizzini and you can read more about me on [jeremyvizzini.com](http://jeremyvizzini.com). On this website I also try to write some articles about mathematics and computer science.

## References

* The MediaInfo library sources are maintened at [https://github.com/MediaArea/MediaInfo](https://github.com/MediaArea/MediaInfo).
* The original dylib is downloadable at [https://mediaarea.net/fr/MediaInfo/Download/Mac_OS](https://mediaarea.net/fr/MediaInfo/Download/Mac_OS)
* The description of mediainfo comes from [https://github.com/jaeguly/libmediainfo](https://github.com/jaeguly/libmediainfo)

## License

MediaInfoKit is released under a MIT license. See the LICENSE file for more information
