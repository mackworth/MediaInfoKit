//
//  Document.m
//  MediaInfo Document
//
//  Created by Hugh Mackworth on 2/18/16.
//  Copyright © 2016 Hugh Mackworth. All rights reserved.
//

#import "Document.h"
#import <MediaInfoKit/MediaInfoKit.h>

@interface Document ()
@property (strong) MIKMediaInfo *mediaInfo;
@property (strong) NSURL * myMovieFile;
@property (strong) NSAttributedString * attributedString;
@end

@implementation Document
@synthesize format=_format;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.attributedString = [[NSAttributedString alloc] initWithString:@"No Video File loaded."];
        self.format = MIKExportFormatRTF;
    }
    return self;
}

- (void) setFormat: (MIKExportFormat) newFormat {
    if (_format != newFormat) {
        _format = newFormat;
        self.attributedString = [self.mediaInfo attributedTextForFormat:newFormat ];
    }
}

-(MIKExportFormat) format {
    return _format;
}

- (void)makeWindowControllers {
    // Override to return the Storyboard file name of the document.
    [self addWindowController:[[NSStoryboard storyboardWithName:@"Main" bundle:nil] instantiateControllerWithIdentifier:@"Document Window Controller"]];
}

- (BOOL)readFromURL:(NSURL *)inAbsoluteURL ofType:(NSString *)inTypeName
              error:(NSError **)outError {

    self.myMovieFile = inAbsoluteURL;
    NSError * error = nil;
    if (![self.myMovieFile checkResourceIsReachableAndReturnError: &error] ) {
        self.attributedString = [[NSAttributedString alloc] initWithString: [NSString stringWithFormat:@"No Video File loaded. %@", error.description]];
        return NO;
    }
    self.mediaInfo = [[MIKMediaInfo alloc] initWithFileURL:inAbsoluteURL];
    if (self.mediaInfo) {
        self.attributedString = self.mediaInfo.attributedText;
        return YES;
    } else {
        self.attributedString = [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"The file %@ is not readable by mediaInfoLib", [self.myMovieFile lastPathComponent]]];
        return NO;
    }
}

-(void) playMovieFile {
    [[NSWorkspace sharedWorkspace] openURL:self.myMovieFile];
}

- (BOOL)writeAsFormat:(MIKExportFormat)format toURL: (nonnull NSURL *)fileURL {
   return [self.mediaInfo writeAsFormat: (MIKExportFormat) format toURL:fileURL];
}

-(NSString *) extensionForFormat:(MIKExportFormat) format {
    return [MIKMediaInfo extensionForFormat:(MIKExportFormat) format];
}

-(NSString *) baseFileName {
    return [self.myMovieFile lastPathComponent];
}

@end
