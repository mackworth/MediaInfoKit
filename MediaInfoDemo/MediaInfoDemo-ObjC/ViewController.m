//
//  ViewController.m
//  MediaInfoDemo-Multi
//
//  This software is released subject to licensing conditions as detailed in LICENCE.md
//

#import "ViewController.h"
#import "Document.h"

#pragma mark - ViewController private

@interface ViewController ()

@property (weak)   IBOutlet NSPopUpButton *formatPopUp;
@property (assign) IBOutlet NSTextView *infoTextView;

@end

#pragma mark - ViewController implementation

@implementation ViewController

-(void) viewWillAppear {
    NSDocumentController *dc = [NSDocumentController sharedDocumentController];
    self.representedObject = [dc documentForWindow:[[self view] window]];
}

#pragma mark Actions

- (IBAction)showMovie:(id)sender {
    [(Document *)self.representedObject openMovieFile];
}

- (IBAction)saveDocumentAs:(id)sender {
    Document * document = (Document *)self.representedObject;
    MIKExportFormat format = document.format;
    NSString *formatExtension = [MIKMediaInfo extensionForFormat:format];

    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setAllowedFileTypes:@[formatExtension]];
    [panel setAllowsOtherFileTypes:NO];
    [panel setExtensionHidden:YES];
    [panel setCanCreateDirectories:YES];
    [panel setNameFieldStringValue:[document baseFilename]];
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            [document writeToURL:[panel URL]];
        }
    }];
}

@end
