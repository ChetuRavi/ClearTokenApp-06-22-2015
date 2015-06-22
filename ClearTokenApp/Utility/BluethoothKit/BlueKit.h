//
//  BlueKit.h
//  ClearTokenApp
//
//  Created by Ravi Patel on 21/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
static  NSString * const sPropertyNames[]={@"Broadcast",@"Read",@"WriteWithoutResponse",@"Write",@"Notify",@"Indicate",@"SignedWrite",
    @"ExtendedProperties",@"NotifyEncryptionRequired",@"IndicateEncryptionRequired"};

@interface BlueKit : NSObject
+ (NSArray *)propertiesFrom:(CBCharacteristicProperties) properties;
+(CBCharacteristicProperties )propertyWithString:(NSString *) string;
@end
