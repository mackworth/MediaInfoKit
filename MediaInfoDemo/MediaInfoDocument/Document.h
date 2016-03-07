//
//  Document.h
//  MediaInfo Document
//
//  Created by Hugh Mackworth on 2/18/16.
//  Copyright © 2016 Hugh Mackworth. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MediaInfoKit/MediaInfoKit.h>

@interface Document : NSDocument

-(BOOL)writeAsFormat:(MIKExportFormat)format toURL:(nonnull NSURL *)fileURL;
-(void) playMovieFile;

@property (nonnull, readonly) NSAttributedString  *attributedString;
@property (assign) MIKExportFormat format;

-(nonnull NSString *) extensionForFormat: (MIKExportFormat) format;
-(nullable NSString *) baseFileName;

@end

