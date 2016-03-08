//
//  MIKMediaInfo.m
//  MediaInfoKit
//
//  This software is released subject to licensing conditions as detailed in LICENCE.md
//
// References : https://mediaarea.net/fr/MediaInfo/Support/SDK/Quick_Start#Quick_Start

#import "MIKMediaInfo.h"
#import "NSString+MIK.h"

#define _UNICODE
#import "MediaInfoDLL.h"

static const NSInteger paddingLenth = 30;

#define FONT_ATTR_DICT(fn, fs) \
    @{NSFontAttributeName:[NSFont fontWithName:fn size:fs]}

#pragma mark - MIKMediaInfo private

@interface MIKMediaInfo ()

@property (readwrite, strong) NSMutableArray *streamNames;
@property (readwrite, strong) NSMutableDictionary *streamsOrder;
@property (readwrite, strong) NSMutableDictionary *streamsInfo;

@end

#pragma mark - MIKMediaInfo implementation

@implementation MIKMediaInfo

+ (void)initialize {
    setenv("LC_CTYPE", "UTF-8", 0);
}

- (nullable instancetype)initWithFileURL:(NSURL *)fileURL {
    self = [super init];
    if (self) {
        MediaInfoDLL::MediaInfo *mi = new MediaInfoDLL::MediaInfo();
        mi->Option([@"setlocale_LC_CTYPE" mik_WCHARString], [@"UTF-8" mik_WCHARString]);
        
        const wchar_t *filename = [[fileURL path] mik_WCHARString];
        size_t res = mi->Open(filename);
        if (!res) {
            NSLog(@"MediaInfo cannot open file: %@", fileURL.path);
            self = nil;
        } else {
            std::basic_string<MediaInfoDLL::Char> rawInfo = mi->Inform();
            NSString *streamInfo = [[NSString alloc] mik_initWithWCHAR:rawInfo.c_str()];
            [self parseStreamInfo:streamInfo];
        }
        mi->Close();
    }
    return self;
}

- (void)parseStreamInfo:(NSString *)info {
    self.streamNames = [NSMutableArray array];
    self.streamsOrder = [NSMutableDictionary dictionary];
    self.streamsInfo = [NSMutableDictionary dictionary];
    
    __block NSString *streamName;
    __block NSMutableArray *currStreamOrder = nil;
    __block NSMutableDictionary *currStreamInfo = nil;
    
    [info enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
        if ([line isEqualToString:@""]) {
            if (streamName) {
                [self.streamNames addObject:streamName];
                [self.streamsOrder setValue:currStreamOrder forKey:streamName];
                [self.streamsInfo setValue:currStreamInfo forKey:streamName];
                streamName = nil;
            }
        } else {
            NSArray *components = [line componentsSeparatedByString:@": "];
            if (components.count == 1) {
                streamName = [components[0] mik_trimmed];
                currStreamOrder = [NSMutableArray array];
                currStreamInfo = [NSMutableDictionary dictionary];
            } else {
                NSString *key = [components[0] mik_trimmed];
                NSMutableString *value = [NSMutableString  stringWithString:components[1]];
                for (int i = 2; i < components.count; i++) {
                    [value appendFormat:@":%@", components[i]];
                }
                [currStreamOrder addObject:key];
                [currStreamInfo setObject:[value mik_trimmed] forKey:key];
            }
        }
    }];
}

#pragma mark Informations

- (NSArray<NSString *> *)streamKeys {
    return (_streamNames != nil) ? _streamNames : @[];
}

- (NSDictionary<NSString *, NSString *> *)valuesForStreamKey:(NSString *)streamKey {
    return (self.streamsInfo[streamKey]) ?: @{};
}

- (NSDictionary *)streams {
    NSMutableDictionary *streams = [NSMutableDictionary dictionary];
    for (NSString *streamKey in self.streamKeys) {
        NSDictionary *streamInfo = [self valuesForStreamKey:streamKey];
        [streams setObject:streamInfo forKey:streamKey];
    }
    return streams;
}

- (NSInteger)countOfValuesForStreamKey:(NSString *)streamKey {
    return [self valuesForStreamKey:streamKey].count;
}

- (nullable NSString *)keyAtIndex:(NSInteger)index forStreamKey:(NSString *)streamKey {
    return [self.streamsOrder objectForKey:streamKey][index];
}

- (nullable NSString *)valueAtIndex:(NSInteger)index forStreamKey:(NSString *)streamKey {
    NSString *key = [self keyAtIndex:index forStreamKey:streamKey];
    return [self valueForKey:key streamKey:streamKey];
}

- (nullable NSString *)valueForKey:(NSString *)infoKey streamKey:(NSString *)streamKey {
    return [self valuesForStreamKey:streamKey][infoKey];
}

#pragma mark Text representation

- (NSString *)text {
    __block NSMutableString *text = [NSMutableString string];

    for (NSString *streamKey in self.streamKeys) {
        [text appendFormat:@"%@ :\n", streamKey];
        [self enumerateValuesForStreamKey:streamKey inOrder:YES block:^(NSString *key, NSString *val) {
            key = [key stringByPaddingToLength:paddingLenth withString:@" " startingAtIndex:0];
            [text appendFormat:@"%@ : %@\n", key, val];
        }];
        [text appendString:@"\n"];
    }
    
    if (text.length > 0) {
        [text deleteCharactersInRange:NSMakeRange(text.length - 1, 1)];
    }
    
    return text;
}

- (NSAttributedString *)attributedText {
    __block NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    __block NSDictionary *titleAttr = FONT_ATTR_DICT(@"Courier-Bold", 13.0);
    __block NSDictionary *valueAttr = FONT_ATTR_DICT(@"Courier", 11.0);
    
    for (NSString *streamKey in self.streamKeys) {
        [text mik_appendAtrributes:titleAttr string:streamKey];
        [text mik_appendAtrributes:titleAttr string:@"\n"];
        [self enumerateValuesForStreamKey:streamKey inOrder:YES block:^(NSString *key, NSString *val) {
            key = [key stringByPaddingToLength:paddingLenth withString:@" " startingAtIndex:0];
            NSString *line = [NSString stringWithFormat:@"%@ : %@\n", key, val];
            [text mik_appendAtrributes:valueAttr string:line];
        }];
        [text mik_appendAtrributes:titleAttr string:@"\n"];
    }
    
    if (text.length > 0) {
        [text deleteCharactersInRange:NSMakeRange(text.length - 1, 1)];
    }
    
    return text;
}

-(NSString *)xmlText {
    NSMutableString *xmlString = [[NSMutableString alloc] init];

    for (NSString *streamKey in self.streamKeys) {
        NSDictionary *streamInfo = [self valuesForStreamKey:streamKey];
        [xmlString appendFormat:@"<%@>\n", streamKey];
        for (NSString *key in [streamInfo allKeys]) {
            NSString *value = streamInfo[key];
            [xmlString appendFormat:@"    <%@>%@</%@>\n", key, value, key];
        }
        [xmlString appendFormat:@"</%@>\n", streamKey];
    }
    return [NSString stringWithString:xmlString];
}

-(NSString *)jsonText {
    NSError *jsonError = nil;
    NSData *jsonData = [NSJSONSerialization  dataWithJSONObject:[self streams]
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:&jsonError];
    if (jsonError) {
        NSLog(@"%@ %s jsonError: error: %@",
              self,
              __PRETTY_FUNCTION__,
              jsonError.localizedDescription);
    }
    if (!jsonData) {
        return nil;
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

-(NSString *)plistText {
    NSError * plistError = nil;
    NSData * plistData = [NSPropertyListSerialization dataWithPropertyList:[self streams]
                                                                    format:NSPropertyListXMLFormat_v1_0
                                                                   options:0
                                                                     error:&plistError];

    if (plistError) {
        NSLog(@"%@ %s plistError: error: %@",
              self,
              __PRETTY_FUNCTION__,
              plistError.localizedDescription);
    }
    if (!plistData) {
        return nil;
    }
    return [[NSString alloc] initWithData:plistData encoding:NSUTF8StringEncoding];
}

-(NSAttributedString *)attributedTextForFormat:(MIKFormat)format {
    NSString *text = nil;
    switch (format) {
        case MIKFormatRTF:   return [self attributedText];
        case MIKFormatTXT:   text = [self text];      break;
        case MIKFormatXML:   text = [self xmlText];   break;
        case MIKFormatJSON:  text = [self jsonText];  break;
        case MIKFormatPLIST: text = [self plistText]; break;
        default:
            NSLog(@"%@ %s format argument is invalid", self, __PRETTY_FUNCTION__);
            break;
    }
    return (text) ? [[NSAttributedString alloc] initWithString:text] : nil;
}

#pragma mark Enumeration

- (void)enumerateValuesForStreamKey:(NSString *)streamKey block:(MIKStreamEnumerationBlock)block {
    [self enumerateValuesForStreamKey:streamKey inOrder:NO block:block];
}

- (void)enumerateOrderedValuesForStreamKey:(NSString *)streamKey block:(MIKStreamEnumerationBlock)block {
    [self enumerateValuesForStreamKey:streamKey inOrder:YES block:block];
}

- (void)enumerateValuesForStreamKey:(NSString *)streamKey
                            inOrder:(BOOL)ordered
                              block:(MIKStreamEnumerationBlock)block
{
    NSDictionary *info = self.streamsInfo[streamKey];
    NSArray *keys = (ordered) ? self.streamsOrder[streamKey] : info.allKeys;
    for (NSString *key in keys) {
        block(key, info[key]);
    }
}

#pragma mark Exportation

- (BOOL)writeAsTXTToURL:(NSURL *)fileURL atomically:(BOOL)useAuxiliaryFile {
    NSString *infoString = [self text];
    NSError *txtError = nil;
    BOOL success = [infoString writeToURL:fileURL
                               atomically:useAuxiliaryFile
                                 encoding:NSUTF8StringEncoding
                                    error:&txtError];
    if (txtError) {
        NSLog(@"%@", [txtError localizedDescription]);
    }
    return success;
}

- (BOOL)writeAsRTFToURL:(NSURL *)fileURL atomically:(BOOL)useAuxiliaryFile {
    NSAttributedString *infoString = [self attributedText];
    
    NSError *rtfError;
    NSDictionary *docAttr = @{NSDocumentTypeDocumentAttribute : NSRTFTextDocumentType};
    NSData *rtfData = [infoString dataFromRange:NSMakeRange(0, [infoString length])
                             documentAttributes:docAttr
                                          error:&rtfError];
    if (rtfError) {
        NSLog(@"%@", [rtfError localizedDescription]);
    }
    
    return [rtfData writeToURL:fileURL atomically:useAuxiliaryFile];;
}

- (BOOL)writeAsXMLToURL:(NSURL *)fileURL atomically:(BOOL)useAuxiliaryFile {

    NSString * xmlString = [self xmlText];
    NSError *xmlError = nil;
    BOOL success = [xmlString writeToURL:fileURL
                              atomically:useAuxiliaryFile
                                encoding:NSUTF8StringEncoding
                                   error:&xmlError];
    if (xmlError) {
        NSLog(@"%@", [xmlError localizedDescription]);
    }
    return success;
}

- (BOOL)writeAsJSONToURL:(NSURL *)fileURL atomically:(BOOL)useAuxiliaryFile {
    NSError *jsonError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self streams]
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&jsonError];
    if (jsonError) {
        NSLog(@"%@", [jsonError localizedDescription]);
    }
    return [jsonData writeToURL:fileURL atomically:useAuxiliaryFile];
}

- (BOOL)writeAsPLISTToURL:(NSURL *)fileURL atomically:(BOOL)useAuxiliaryFile {
    return [[self streams] writeToURL:fileURL atomically:useAuxiliaryFile];
}

+ (NSString *)extensionForFormat:(MIKFormat)format {
    NSString *extension = nil;
    switch (format) {
        case MIKFormatTXT:   extension = @"txt";   break;
        case MIKFormatRTF:   extension = @"rtf";   break;
        case MIKFormatXML:   extension = @"xml";   break;
        case MIKFormatJSON:  extension = @"json";  break;
        case MIKFormatPLIST: extension = @"plist"; break;
        default: break;
    }
    return extension;
}

- (BOOL)writeAsFormat:(MIKFormat)format toURL:(NSURL *)fileURL {
    return [self writeAsFormat:format toURL:fileURL atomically:YES];
}

- (BOOL)writeAsFormat:(MIKFormat)format toURL:(NSURL *)fileURL atomically:(BOOL)flag {
    BOOL success = NO;
    switch (format) {
        case MIKFormatTXT:   success = [self writeAsTXTToURL:fileURL atomically:flag];   break;
        case MIKFormatRTF:   success = [self writeAsRTFToURL:fileURL atomically:flag];   break;
        case MIKFormatXML:   success = [self writeAsXMLToURL:fileURL atomically:flag];   break;
        case MIKFormatJSON:  success = [self writeAsJSONToURL:fileURL atomically:flag];  break;
        case MIKFormatPLIST: success = [self writeAsPLISTToURL:fileURL atomically:flag]; break;
        default:
            NSLog(@"%@ %s format argument is invalid", self, __PRETTY_FUNCTION__);
            break;
    }
    return success;
}

#pragma mark Options

+ (void)setUseInternetConnection:(BOOL)use {
    const wchar_t *value = use ? [@"No" mik_WCHARString] : [@"Yes" mik_WCHARString];
    MediaInfoDLL::MediaInfo::Option_Static([@"Internet" mik_WCHARString], value);
}

+ (void)setLanguageWithContents:(NSString *)langContents {
    MediaInfoDLL::MediaInfo::Option_Static([@"Language" mik_WCHARString], [langContents mik_WCHARString]);
}

@end
