//
//  MIKExportFormat.h
//  MediaInfoKit
//
//  This software is released subject to licensing conditions as detailed in LICENCE.md
//

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
