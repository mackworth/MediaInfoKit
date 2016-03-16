//
//  NSString+MIK.h
//  MediaInfoKit
//
//  This software is released subject to licensing conditions as detailed in LICENCE.md
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - NSString + MIK

@interface NSString (MIK)

#pragma mark WChar

- (instancetype)mik_initWithWCHAR:(const wchar_t *)str;
- (const wchar_t *)mik_WCHARString;
+ (int)mik_wchar4ByteEncoding;

#pragma mark Utilities

- (NSString *)mik_trimmed;

@end


#pragma mark - NSMutableAttributedString + MIK

@interface NSMutableAttributedString (MIK)

- (void)mik_appendAtrributes:(NSDictionary *)attr string:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
