//
//  NSURLRequest+ClTWebservice.h

//
///  Created by Chetu on 12/05/15.
//  Copyright (c) 2015 Chetu. All rights reserved.
//



#import <Foundation/Foundation.h>

#import "ClTWebservice.h"


@interface NSURLRequest (ClTWebservice)

/*********************************************************************************************************************
    @function	-getCompleteRequestWithServiceName:
	@discussion	 This is instance method which handle get and post request and making the connection.
	@param	This Method takes three parameter
    1.serviceName-> This parameter is appened to BaseURL
    2.params->This parameter is use hold Data in Dictionary format
    3.type-> This parameter have get or post type
 	@result	
*********************************************************************************************************************/

-(id)getCompleteRequestWithServiceName:(NSString*)serviceName params:(NSMutableDictionary*)params type:(RequestType)type;
@end
