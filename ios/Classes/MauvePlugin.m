#import "MauvePlugin.h"
#if __has_include(<mauve/mauve-Swift.h>)
#import <mauve/mauve-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "mauve-Swift.h"
#endif

@implementation MauvePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMauvePlugin registerWithRegistrar:registrar];
}
@end
