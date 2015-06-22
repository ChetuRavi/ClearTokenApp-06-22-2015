//
//  Utility.m
//  ClearTokenApp
//
//  Created by Ravi Patel on 20/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import "Utility.h"
#import "Constant.h"
#import "AppDelegate.h"


@implementation Utility



//+(Utility*)sharedInstance{
//    static Utility *sharedInstance=nil;
//    static dispatch_once_t oncePedicate;
//    dispatch_once(&oncePedicate,^{
//        sharedInstance=[[Utility alloc]init];
//            });
//    return sharedInstance;
//}




/*********************************************************************************
	@function	-SetBackGroundColor:
	@discussion	 This is class method which is return the color according to device name.
	@param  This method take one parameter DeviceName;
	@result	 N/A
 *********************************************************************************/

+(UIColor*)SetBackGroundColor:(NSString *)DeviceName
{
    
    //    0 or 5 = Orange #FF8800
    //    1 or 6 = Purple  #9933CC
    //    2 or 7 = Green  #669900
    //    3 or 8 = Blue     #0099CC
    //    4 or 9 = Red      #CC0000
    NSString *lastChar = [DeviceName substringFromIndex:[DeviceName length] - 1];
    
    if ([lastChar isEqual:@"0"] || [lastChar isEqual:@"5"]) {
        
        //return [UIColor yelloColor];
        
        return [UIColor colorWithRed:255.0/255.0 green:193.0/255.0 blue:7.0/255.0 alpha:1];
    }
    else if ([lastChar isEqual:@"1"] || [lastChar isEqual:@"6"]) {
        //return [UIColor purpleColor];
        
        return [UIColor colorWithRed:103.0/255.0 green:58.0/255.0 blue:215/255.0 alpha:1];
    }
    else if ([lastChar isEqual:@"2"] || [lastChar isEqual:@"7"]) {
        // return [UIColor greenColor];
        
        return [UIColor colorWithRed:76.0/255.0 green:175.0/255.0 blue:80.0/255.0 alpha:1];
        
    }
    else if ([lastChar isEqual:@"3"] || [lastChar isEqual:@"8"]) {
        // return [UIColor blueColor];
        
        return [UIColor colorWithRed:3.0/255.0 green:169.0/255.0 blue:244.0/255.0 alpha:1];
        
    }
    else if ([lastChar isEqual:@"4"] || [lastChar isEqual:@"9"]) {
        //return [UIColor redColor];
        return [UIColor colorWithRed:244.0/255.0 green:67.0/255.0 blue:54.0/255.0 alpha:1];
    }
    //return [UIColor clearColor];
    return [UIColor colorWithRed:158.0/255.0 green:158.0/255.0 blue:158.0/255.0 alpha:1];
    
}




/*********************************************************************************
	@function	-showAlertMessage:
	@discussion	 This is class method which is display the alert message.
	@param  This method takes two parameter one message and another parameter message Title;
	@result	 N/A
 *********************************************************************************/
+ (void)showAlertMessage:(NSString*)message withTitle:(NSString *)title
{
    UIAlertView *alert= [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}



/*********************************************************************************
	@function	-unitStringWithIncrements:
	@discussion	 This is class method which is display the alert message.
	@param  This method takes two parameter one message and another parameter message Title;
	@result	 N/A
 *********************************************************************************/

+(NSString *)unitStringWithIncrements:(NSString *)Increments
{
    NSString *maxIncreament=Increments;
    NSString *unit=APP_DELEGATE.responceDataObject.stringUnits;
    
    if ([maxIncreament isEqualToString:@"1"] && [unit isEqualToString:@"M"]) {
        return @"Minute";
    }
    else if([maxIncreament isEqualToString:@"1"] && [unit isEqualToString:@"H"]){
        return @"Hour";
        
    }
    else if (([maxIncreament intValue]>1) && [unit isEqualToString:@"M"]) {
        return @"Minutes";
    }
    else if (([maxIncreament intValue]>1) && [unit isEqualToString:@"H"]) {
        return @"Hours";
    }
    
    return @"";
}


@end
