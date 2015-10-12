//
//  MIKMediaInfo.h
//  MediaInfoKit
//
//  Created by Jeremy Vizzini.
//  This software is released subject to licensing conditions as detailed in LICENCE.md
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const GeneralStreamKey;
extern NSString * const VideoStreamKey;
extern NSString * const AudioStreamKey;
extern NSString * const Audio1StreamKey;
extern NSString * const Audio2StreamKey;

typedef NS_ENUM(NSUInteger, MIKExportFormat) {
    MIKExportFormatTXT,
    MIKExportFormatRTF,
    MIKExportFormatXML,
    MIKExportFormatJSON,
    MIKExportFormatPLIST
};

#pragma mark - MIKMediaInfo

@interface MIKMediaInfo : NSObject

#pragma mark Initializers

- (nullable instancetype)initWithFileURL:(NSURL *)fileURL;

#pragma mark Informations

@property(readonly, strong, nonatomic) NSArray<NSString *> * streamKeys;

- (NSDictionary<NSString *, NSString *> *)infoForStreamKey:(NSString *)streamKey;
- (nullable NSString *)valueForKey:(NSString *)infoKey streamKey:(NSString *)streamKey;

- (NSInteger)infoCountForStreamKey:(NSString *)streamKey;
- (nullable NSString *)keyAtIndex:(NSInteger)index forStreamKey:(NSString *)streamKey;
- (nullable NSString *)valueAtIndex:(NSInteger)index forStreamKey:(NSString *)streamKey;

#pragma mark Text description

@property (readonly, strong, nonatomic) NSString *text;
@property (readonly, strong, nonatomic) NSAttributedString *attributedText;

#pragma mark Enumeration

typedef void(^StreamEnumerationBlock)(NSString *key, NSString *value);
- (void)enumerateInfoForStreamKey:(NSString *)streamKey block:(StreamEnumerationBlock)block;
- (void)enumerateOrderedInfoForStreamKey:(NSString *)streamKey block:(StreamEnumerationBlock)block;

#pragma mark Exportation

+ (NSString *)extensionForFormat:(MIKExportFormat)format;
- (BOOL)writeAsFormat:(MIKExportFormat)format toURL:(NSURL *)fileURL;
- (BOOL)writeAsFormat:(MIKExportFormat)format toURL:(NSURL *)fileURL atomically:(BOOL)flag;

#pragma mark Change language

+ (void)setLanguageWithContents:(NSString *)langContents;

@end

NS_ASSUME_NONNULL_END
