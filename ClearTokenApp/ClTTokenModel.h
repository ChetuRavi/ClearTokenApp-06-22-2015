//
//  ClTTokenModel
//  ClearTokenApp
//
//  Created by Ravi Patel on 15/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.//

#import <Foundation/Foundation.h>



@interface ClTTokenModel : NSObject


@property (strong,nonatomic) NSString *stringToken;

+(ClTTokenModel*)sharedInstance;
  

@end
