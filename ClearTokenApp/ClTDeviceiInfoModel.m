//
//  ClTDeviceiInfoModel.m
//  ClearTokenApp
//
//  Created by Ravi Patel on 15/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import "ClTDeviceiInfoModel.h"

@implementation ClTDeviceiInfoModel

/**************************************************************************************
//create the singleton instance of ClTDeviceiInfoModel class
**************************************************************************************/


+(ClTDeviceiInfoModel*)sharedInstance{
    
    static ClTDeviceiInfoModel *sharedInstance = nil;
    static dispatch_once_t oncePedicate;
    dispatch_once(&oncePedicate, ^{
        
        sharedInstance = [[ClTDeviceiInfoModel alloc] init];
    });
    return sharedInstance;
}






/**************************************************************************************
//Default initialize ClTDeviceiInfoModel class with it's property set to nil value
**************************************************************************************/
-(id)init
{
    
    self=[super init];
    if (self) {
        
      _stringCurrentStatus=@"Init sting";
        _stringDeviceId=@"";
        _numberFee=0;
        _stringLatitude=@"";
        _stringLocation=@"";
        _stringLongitude=@"";
        _stringMaxIncrements=@"";
        _stringOwnerID=@"";
        _stringType=@"";
        _stringUnits=@"";
        _stringZone=@"";
       
    }

    return self;
}

@end
