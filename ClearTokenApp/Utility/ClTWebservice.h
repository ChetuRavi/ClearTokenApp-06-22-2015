//
//  ClTWebservice.h

//
//  Created by Chetu on 12/05/15.
//  Copyright (c) 2015 Chetu. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Constant.h"


typedef void (^OnSuccess) (NSMutableDictionary *response);
typedef void (^OnFailure) (NSError *error);
typedef void (^OnNullResponse) ();

@interface ClTWebservice : NSObject

/*********************************************************************************************************************
	@function	+sharedInstance:
	@discussion	This is class method which create the its own class instance only ones
	@param	nil.
	@result
 *********************************************************************************************************************/

+(ClTWebservice*)sharedInstance;





/*********************************************************************************************************************
	@function	-callWebserviceWithServiceIdentifier:
	@discussion	 This is instance method which is call the webservice and and handle the responce data.
	@param	In this method has 6 parameter 
            1.ServiceIdentifier-> This parameter use for service method Identifier
            2.params->This parater hold the service required data
            3.requestType-> This parameter inform the get or post tupe request
            4.successBlock-> This block parameter hold the sussessBlock responce
            5.OnFailure-> This block parameter hold the failureBlock responce
            6.nullResponse-> This block parameter hold the nullResponse
	@result	 
**********************************************************************************************************************/

- (void)callWebserviceWithServiceIdentifier:(ServiceIdentifier)serviceIdentifier params:(NSString *)params requestType:(RequestType)requestType Oncompletion:(OnSuccess)successBlock OnFailure:(OnFailure)failureBlock nullResponse:(OnNullResponse)nullResponse;

@end
