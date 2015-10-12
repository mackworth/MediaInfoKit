//
//  AppDelegate.m
//  MediaInfoDemo-Objc
//
//  Created by Jeremy Vizzini.
//  This software is released subject to licensing conditions as detailed in LICENCE.md
//

#import "AppDelegate.h"

#pragma mark - AppDelegate Private

@interface AppDelegate ()

@property (weak)   IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextView *infoTextView;
@property (weak)   IBOutlet NSPopUpButton *formatPopUp;
@property (strong) MIKMediaInfo *mediaInfo;

@end

#pragma mark - AppDelegate Implementation

@implementation AppDelegate

#pragma mark NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self loadMediaInfo];
}

#pragma mark MediaInfo

- (NSString *)movieFileName {
    return @"BBB";
}

- (NSURL *)movieFileURL {
    return [[NSBundle mainBundle] URLForResource:[self movieFileName] withExtension:@"mov"];
}

- (void)loadMediaInfo {
    self.mediaInfo = [[MIKMediaInfo alloc] initWithFileURL:[self movieFileURL]];
    if (self.mediaInfo) {
        [self.infoTextView insertText:self.mediaInfo.attributedText];
    } else {
        [self.infoTextView insertText:@"The movie is not readable by mediainfolib"];
    }
}

#pragma mark Actions

- (IBAction)showMovie:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[self movieFileURL]];
}

- (IBAction)extractInfo:(id)sender {
    MIKExportFormat format = self.formatPopUp.indexOfSelectedItem;
    NSString *formatExtension = [MIKMediaInfo extensionForFormat:format];
    
    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setAllowedFileTypes:@[formatExtension]];
    [panel setAllowsOtherFileTypes:NO];
    [panel setExtensionHidden:YES];
    [panel setCanCreateDirectories:YES];
    [panel setNameFieldStringValue:[self movieFileName]];
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
           [self.mediaInfo writeAsFormat:format toURL:panel.URL];
        }
    }];
}

@end
