//
//  NSString+MIK.mm
//  MediaInfoKit
//
//  This software is released subject to licensing conditions as detailed in LICENCE.md
//

#import "NSString+MIK.h"
#include "wchar.h"

#pragma mark NSString + MIK

@implementation NSString (MIK)

#pragma mark WChar

- (instancetype)mik_initWithWCHAR:(const wchar_t *)str {
    int encoding = [NSString mik_wchar4ByteEncoding];
    size_t len = wcslen(str) * sizeof(wchar_t);
    return [self initWithBytes:(char *)str length:len encoding:encoding];
}

- (const wchar_t *)mik_WCHARString {
    int encoding = [NSString mik_wchar4ByteEncoding];
    return (wchar_t *)[self cStringUsingEncoding:encoding];
}

+ (int)mik_wchar4ByteEncoding {
    return NSUTF32LittleEndianStringEncoding;
}

#pragma mark Utilities

- (NSString *)mik_trimmed {
    NSCharacterSet *blankCharSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:blankCharSet];
}

@end

#pragma mark NSMutableAttributedString + MIK

@implementation NSMutableAttributedString (MIK)

- (void)mik_appendAtrributes:(NSDictionary *)attr string:(NSString *)string {
    NSAttributedString *attrString;
    attrString = [[NSAttributedString alloc] initWithString:string attributes:attr];
    [self appendAttributedString:attrString];
}

@end
