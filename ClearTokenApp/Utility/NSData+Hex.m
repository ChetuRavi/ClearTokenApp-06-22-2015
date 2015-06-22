//
//  NSData+Hex.m
//  ClearTokenApp
//
//  Created by Ravi Patel on 21/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import "NSData+Hex.h"

@implementation NSData(Hex)


/**************************************************************************************
	@function	-hexadecimalString:
	@discussion	This  method convert the data to hexadecimalString
	@param	N/A.
	@result	 N/A
**************************************************************************************/

- (NSString *)hexadecimalString {
       
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [self length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}




/**************************************************************************************
	@function	-dataWithHexString:
	@discussion	This  method convert the hexadecimal String  to NSData
	@param	This method take hexstring as parameter and convert this NSstring to NSData and return it.
	@result	N/A
**************************************************************************************/

+ (NSData *)dataWithHexString:(NSString *)hexstring
{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= hexstring.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [hexstring substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}
@end
