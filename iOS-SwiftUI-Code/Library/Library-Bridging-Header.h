//
//  Library-Bridging-Header.h
//  Library
//
//  Bridging header for Libbox.xcframework
//

// Import Libbox Objective-C headers for Swift access
// Note: The framework must be linked and framework search paths must be set correctly

#if __has_include(<Libbox/Libbox.h>)
#import <Libbox/Libbox.h>
#elif __has_include("Libbox.h")
#import "Libbox.h"
#endif