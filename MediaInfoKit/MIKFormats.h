//
//  MIKFormats.h
//  MediaInfoKit
//
//  Created by Hugh Mackworth on 2/20/16.
//  Copyright © 2016 Jeremy Vizzini. All rights reserved.
//

#ifndef MIKFormats_h
#define MIKFormats_h


#endif /* MIKFormats_h */

/**
 *  The different export formats available.
 */
typedef NS_ENUM(NSUInteger, MIKExportFormat) {
    /**
     *  Export mediainfo as a plain text.
     */
    MIKExportFormatTXT,
    /**
     *  Export mediainfo as a rich text.
     */
    MIKExportFormatRTF,
    /**
     *  Export mediainfo in a XML format.
     */
    MIKExportFormatXML,
    /**
     *  Export mediainfo in a JSON format.
     */
    MIKExportFormatJSON,
    /**
     *  Export mediainfo in a PLIST format.
     */
    MIKExportFormatPLIST
};
