#import "ConvertVersion.h"

@implementation ConvertVersion

-(int) numberToCode:(NSString *) versionNumber{
    if (versionNumber == (id)[NSNull null] || versionNumber.length == 0 ){
        return 0;
    }
    NSArray *versionArray = [versionNumber componentsSeparatedByString:@"."];
    NSString* major = [versionArray objectAtIndex:0];
    NSString* minor = [versionArray objectAtIndex:1];
    NSString* build = [versionArray objectAtIndex:2];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSNumber *majorCode = [f numberFromString:major];   
   
    NSNumber *minorCode = [f numberFromString:minor];
    
    NSNumber *buildCode = [f numberFromString:build];    
    
    int versionCode = ([majorCode intValue] * 10000 ) + ([minorCode intValue] * 100) + ([buildCode intValue]);
    return versionCode;
}

@end