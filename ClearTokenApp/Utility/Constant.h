//
//  Constant.h
//  webServicesExample
//
//  Created by Ravi Patel on 12/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#ifndef webServicesExample_Constant_h
#define webServicesExample_Constant_h
#import "AppDelegate.h"

typedef enum RequestType{
    kPost,
    kGet
}RequestType;



typedef enum ServiceIdentifier
{
    kGetDeviceInfo,
    kGetDeviceToken,
    kGetPin,
    kGetVerify
}ServiceIdentifier;


typedef enum ErrorType{
    kNetworkNotFound,
    kParameterNotProper,
}ErrorType;

typedef enum bluetoothStatus{
    kOn,
    kOFF,
}bluetoothStatus;





#define BASE_URL @"http://www.cleartoken.com/services/"

#define DUUID @"c9cab9b8-3abf-4043-a5af-9ad00c6074d5"

#define StatusDisconnected @"disconnected"
#define statusConnectedFailed @"ConnectedFailed"
#define statusConnected @"Connected"

#define NullResponceMessage @"Network not available, please check your internet settings."



#define APP_DELEGATE  ((AppDelegate *)[[UIApplication sharedApplication] delegate])



#endif
