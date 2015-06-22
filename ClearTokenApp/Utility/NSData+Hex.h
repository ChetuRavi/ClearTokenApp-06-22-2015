//
//  NSData+Hex.h
//  ClearTokenApp
//
//  Created by Ravi Patel on 21/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(Hex)
- (NSString *)hexadecimalString;
+ (NSData *)dataWithHexString:(NSString *)hexstring;
@end
