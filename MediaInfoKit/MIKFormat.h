//
//  MIKFormat.h
//  MediaInfoKit
//
//  This software is released subject to licensing conditions as detailed in LICENCE.md
//

/**
 *  The different text formats available.
 */
typedef NS_ENUM(NSUInteger, MIKFormat) {
    /**
     *  Informations as a plain text.
     */
    MIKFormatTXT,
    /**
     *  Informations as a rich text.
     */
    MIKFormatRTF,
    /**
     *  Informations in a XML format.
     */
    MIKFormatXML,
    /**
     *  Informations in a JSON format.
     */
    MIKFormatJSON,
    /**
     *  Informations in a PLIST format.
     */
    MIKFormatPLIST
};
