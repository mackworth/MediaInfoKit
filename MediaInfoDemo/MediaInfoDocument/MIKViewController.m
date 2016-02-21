//
//  ViewController.m
//  MediaInfo Document
//
//  Created by Hugh Mackworth on 2/18/16.
//  Copyright © 2016 Hugh Mackworth. All rights reserved.
//

#import "MIKViewController.h"
#import "Document.h"

@interface MIKViewController ()
@property (weak)   IBOutlet NSPopUpButton *formatPopUp;
@property (assign) IBOutlet NSTextView *infoTextView;
@end

@implementation MIKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) viewWillAppear {
    self.representedObject = [[NSDocumentController sharedDocumentController] documentForWindow:[[self view] window]];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

#pragma mark Actions
-(IBAction) changeFormat:(NSPopUpButton *)popup {
}

- (IBAction)showMovie:(id)sender {
    [(Document *)self.representedObject playMovieFile];
}

- (IBAction)extractInfo:(id)sender {
    Document * document = (Document *)self.representedObject;
    MIKExportFormat format = self.formatPopUp.indexOfSelectedItem;
    NSString *formatExtension = [document extensionForFormat: format];

    NSSavePanel *panel = [NSSavePanel savePanel];
    [panel setAllowedFileTypes:@[formatExtension]];
    [panel setAllowsOtherFileTypes:NO];
    [panel setExtensionHidden:YES];
    [panel setCanCreateDirectories:YES];
    [panel setNameFieldStringValue:[document baseFileName]];
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            [document writeAsFormat:format toURL:panel.URL];
        }
    }];
}

@end
