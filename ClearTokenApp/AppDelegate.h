//
//  AppDelegate.h
//  ClearTokenApp
//
//  Created by Ravi Patel on 15/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClTDeviceiInfoModel.h"
#import "Peripheral.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong, nonatomic) Peripheral *perpheralModelObject;
@property(strong, nonatomic) ClTDeviceiInfoModel *responceDataObject;



@end

