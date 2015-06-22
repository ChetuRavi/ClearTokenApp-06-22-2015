//
//  ClTTokenModel.m
//  ClearTokenApp
//
//  Created by Ravi Patel on 15/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//


#import "ClTDataModel.h"
#import  "ClTTokenModel.h"



@implementation ClTTokenModel

/**************************************************************************************
//create the singleton instance of ClTTokenModel class
**************************************************************************************/
+(ClTTokenModel*)sharedInstance{
    
    static ClTTokenModel *sharedInstance = nil;
    static dispatch_once_t oncePedicate;
    dispatch_once(&oncePedicate, ^{
        
        sharedInstance = [[ClTTokenModel alloc] init];
    });
    return sharedInstance;
}



/**************************************************************************************
//Default initialize ClTTokenModel class wiht its property set to nil value
**************************************************************************************/

-(id)init
{
    
    self=[super init];
    if (self) {
        
              _stringToken=@"";
           }
    
    return self;
}





@end
