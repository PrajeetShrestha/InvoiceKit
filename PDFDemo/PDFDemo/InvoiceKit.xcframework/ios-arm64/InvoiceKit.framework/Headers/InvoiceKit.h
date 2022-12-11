//
//  InvoiceKit.h
//  InvoiceKit
//
//  Created by Prajeet Shrestha on 09/12/2022.
//

#import <Foundation/Foundation.h>

//! Project version number for InvoiceKit.
FOUNDATION_EXPORT double InvoiceKitVersionNumber;

//! Project version string for InvoiceKit.
FOUNDATION_EXPORT const unsigned char InvoiceKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <InvoiceKit/PublicHeader.h>


xcodebuild archive \
-scheme InvoiceKit \
-destination "generic/platform=iOS" \
-archivePath ../output/InvoiceKit \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES
