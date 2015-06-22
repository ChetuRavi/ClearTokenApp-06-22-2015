//
//  ClTUtility.h
//  ClearToken
//
//  Created by Ravi Patel on 08/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClTUtility : NSObject

//+ (ClTUtility *)sharedDetails;

//+ (void)showAlertMessage:(NSString *)message ;

+ (BOOL) checkNetworkStatus ;

@property (assign, nonatomic) BOOL isInternetConnection;




@end
