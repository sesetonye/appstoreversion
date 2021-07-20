/********* AppStoreInfo.m Cordova Plugin Implementation *******/
#import "AppStoreInfo.h"
#import "ConvertVersion.h"

@implementation AppStoreInfo

- (void)appInfo:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult *pluginResult = nil;
     NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString* appID = infoDictionary[@"CFBundleIdentifier"];
        //NSString* appID = @"1516965769";
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", appID]];
        NSData* data = [NSData dataWithContentsOfURL:url];
        NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSString* appStoreVersion = NULL;
    
        NSMutableDictionary *response = [[NSMutableDictionary alloc] initWithCapacity:2];    

        if ([lookup[@"resultCount"] integerValue] == 1){

            ConvertVersion *convert = [[ConvertVersion alloc] init];

            appStoreVersion = lookup[@"results"][0][@"version"];
            NSString* currentVersion = infoDictionary[@"CFBundleShortVersionString"];

            int appStoreVersionCode = [convert numberToCode: appStoreVersion];
            int localVersionCode = [convert numberToCode: currentVersion];

            [response setObject:[NSNumber numberWithInt:appStoreVersionCode] forKey: @"storeVersion"];
            [response setObject:[NSNumber numberWithInt:localVersionCode] forKey: @"localVersion"];
              
            NSLog(@"App Version = [%@]", appStoreVersion);
        } else{
            [response setObject:[NSNumber numberWithInt:0] forKey: @"storeVersion"];
            [response setObject:[NSNumber numberWithInt:0] forKey: @"localVersion"];
              
            appStoreVersion = @"FALSE";
        }
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:response];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


@end