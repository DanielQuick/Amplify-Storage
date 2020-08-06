#import "AmplifyStoragePlugin.h"
#if __has_include(<amplify_storage/amplify_storage-Swift.h>)
#import <amplify_storage/amplify_storage-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "amplify_storage-Swift.h"
#endif

@implementation AmplifyStoragePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAmplifyStoragePlugin registerWithRegistrar:registrar];
}
@end
