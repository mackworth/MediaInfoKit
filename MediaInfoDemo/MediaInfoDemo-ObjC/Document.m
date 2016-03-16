//
//  Document.m
//  MediaInfoDemo-ObjC
//
//  This software is released subject to licensing conditions as detailed in LICENCE.md
//

#import "Document.h"
#import <MediaInfoKit/MediaInfoKit.h>

#pragma mark - Document private

@interface Document ()

@property (strong) MIKMediaInfo *mediaInfo;
@property (strong) NSAttributedString *attributedString;

@end

#pragma mark - Document private

@implementation Document

@synthesize format = _format;

#pragma mark Initializer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.attributedString = [[NSAttributedString alloc] initWithString:@"No Video File loaded."];
        self.format = MIKFormatRTF;
    }
    return self;
}

- (void)makeWindowControllers {
    NSString *identifier = @"Document Window Controller";
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    [self addWindowController:[storyboard instantiateControllerWithIdentifier:identifier]];
}

- (BOOL)readFromURL:(NSURL *)inAbsoluteURL ofType:(NSString *)inTypeName error:(NSError **)outError {
    NSError *error = nil;
    if (![self.fileURL checkResourceIsReachableAndReturnError:&error]) {
        NSString *desc = [NSString stringWithFormat:@"No Video File loaded. %@", error.description];
        self.attributedString = [[NSAttributedString alloc] initWithString: desc];
        return NO;
    }
    
    self.mediaInfo = [[MIKMediaInfo alloc] initWithFileURL:inAbsoluteURL];
    if (!self.mediaInfo) {
        NSString *filename = [self.fileURL lastPathComponent];
        NSString *desc = [NSString stringWithFormat:@"The file %@ is not readable by mediaInfoLib", filename];
        self.attributedString = [[NSAttributedString alloc] initWithString:desc];
        return NO;
    }
    
    self.attributedString = [self.mediaInfo attributedTextForFormat:self.format];
    return YES;
}

#pragma mark Getters setters

-(NSString *)baseFilename {
    return [self.fileURL lastPathComponent];
}

- (MIKFormat) format {
    return _format;
}

- (void)setFormat:(MIKFormat)format {
    if (_format == format) {
        return;
    }
    
    _format = format;
    self.attributedString = [self.mediaInfo attributedTextForFormat:format];
}

#pragma mark Actions

- (void)openMovieFile {
    [[NSWorkspace sharedWorkspace] openURL:self.fileURL];
}

- (BOOL)writeToURL:(nonnull NSURL *)fileURL {
   return [self.mediaInfo writeAsFormat:self.format toURL:fileURL];
}

@end
