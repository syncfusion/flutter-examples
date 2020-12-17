#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"

@implementation AppDelegate
UIDocumentInteractionController* _uiController;
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
      FlutterViewController* controller =(FlutterViewController*) self.window.rootViewController;

            FlutterMethodChannel* viewPdfFileChannel = [FlutterMethodChannel methodChannelWithName:@"launchFile" binaryMessenger: controller.binaryMessenger];

            [viewPdfFileChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
                if ([@"viewPdf" isEqualToString:call.method] || [@"viewExcel" isEqualToString:call.method]) {
                    NSString* filePath = call.arguments[@"file_path"];
                    NSFileManager* fileManager = [NSFileManager defaultManager];
                    BOOL fileExist = [fileManager fileExistsAtPath:filePath];
                    if(fileExist){
                        NSString* fileExtension = [filePath pathExtension];
                       _uiController  = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
                        _uiController.delegate = (id)self;
                        if([fileExtension isEqualToString:@"pdf"]){
                            _uiController.UTI = @"com.adobe.pdf";
                        }
                        if([fileExtension isEqualToString:@"xlsx"]){
                            _uiController.UTI = @"com.microsoft.excel.xls";
                        }
                        else if([fileExtension isEqualToString:@"txt"]){
                            _uiController.UTI = @"public.plain-text";
                        }
                        else{
                            NSLog(@"The format %@ is not supported ", filePath);
                        }
                        @try {
                            BOOL isPreview = [_uiController presentPreviewAnimated:YES];
                            if(!isPreview){
                                [_uiController presentOpenInMenuFromRect:CGRectMake(200, 20, 100, 100) inView: controller.view animated:YES];
                            }

                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                        }
                    }
                }
            }];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
