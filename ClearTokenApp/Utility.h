//
//  Utility.h
//  ClearTokenApp
//
//  Created by Ravi Patel on 20/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ClTDeviceiInfoModel.h"

@interface Utility : NSObject

@property(strong, nonatomic) ClTDeviceiInfoModel *clTDeviceInfoModelObject;

//+(Utility*)sharedInstance;
+(UIColor*)SetBackGroundColor:(NSString *)lastChar;
+ (void)showAlertMessage:(NSString*)message withTitle:(NSString *)title;
+(NSString *)unitStringWithIncrements:(NSString *)Increments;
@end
