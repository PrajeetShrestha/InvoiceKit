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

/*
xcodebuild archive \
-scheme InvoiceKit \
-destination "generic/platform=iOS" \
-archivePath ../output/InvoiceKit \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES


xcodebuild archive \
-scheme InvoiceKit \
-destination "generic/platform=iOS Simulator" \
-archivePath ../output/InvoiceKit-Sim \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES

cd ./output
xcodebuild -create-xcframework \
-framework ./InvoiceKit.xcarchive/Products/Library/Frameworks/InvoiceKit.framework \
-framework ./InvoiceKit-Sim.xcarchive/Products/Library/Frameworks/InvoiceKit.framework \
-output ./InvoiceKit.xcframework
*/
/* https://medium.com/@elmoezamira/build-your-first-xcframework-how-to-create-an-ios-framework-pt-1-d1a889fdb40d
 */
