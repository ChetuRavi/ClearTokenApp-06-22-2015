//
//  BlueKit.m
//  ClearTokenApp
//
//  Created by Ravi Patel on 21/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import "BlueKit.h"

@implementation BlueKit


/*********************************************************************************
 Find the property from of characteristic and return the array
 *********************************************************************************/

+ (NSArray *)propertiesFrom:(CBCharacteristicProperties) properties
{
    int c = sizeof(sPropertyNames)/sizeof(NSString*);
    NSMutableArray * temp = [NSMutableArray arrayWithCapacity:c];
    for (int i =0 ; i!= c; ++i)
    {
        NSInteger t = 0x1<<i;
        if ((t&properties) !=0)
        {
            [temp addObject:sPropertyNames[i]];
        }
    }
    return temp;
}




/*********************************************************************************
 find the service Characteristic
 *********************************************************************************/

+(CBCharacteristicProperties )propertyWithString:(NSString *) string
{
    int c = sizeof(sPropertyNames)/sizeof(NSString*);
    CBCharacteristicProperties t=0;
    for (int i =0 ; i!= c; ++i)
    {
        if ([sPropertyNames[i] isEqualToString:string])
        {
            t = 0x1<<i;
            break;
        }
    }
    return t;
}
@end
