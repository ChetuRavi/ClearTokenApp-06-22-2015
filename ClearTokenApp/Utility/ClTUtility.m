//
//  ClTUtility.m
//  ClearToken
//
//  Created by Ravi Patel on 08/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ClTUtility.h"
#import "ClTReachability.h"

@implementation ClTUtility



/*!
 *  Method to check the network.
 *  @return Bool value.
 *  @since <#version number#>
 */

+ (BOOL)checkNetworkStatus {
    //Rechability call.
    Reachability *internetReachable= [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    
    BOOL isInternetActive = NO;
    switch (internetStatus)
    {
        case NotReachable:
        {
            isInternetActive = NO;
            break;
        }
        case ReachableViaWiFi:
        {
            isInternetActive = YES;
            break;
        }
        case ReachableViaWWAN:
        {
            isInternetActive = YES;
            break;
        }
        default:
        {
            isInternetActive = NO;
            break;
        }
    }
    return isInternetActive;
}




@end
