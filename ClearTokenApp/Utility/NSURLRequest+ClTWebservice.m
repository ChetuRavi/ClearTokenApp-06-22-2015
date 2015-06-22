//
//  NSURLRequest+ClTWebservice.m

//
//  Created by Chetu on 12/05/15.
//  Copyright (c) 2015 Chetu. All rights reserved.
//

#import "NSURLRequest+ClTWebservice.h"
#import "ClTWebservice.h"


@implementation NSURLRequest (ClTWebservice)


/*********************************************************************************************************************
	@function	-getCompleteRequestWithServiceName:
	@discussion	 This is instance method which handle get and post request and making the connection.
	@param	This Method takes three parameter
        1.serviceName-> This parameter is appened to BaseURL
        2.params->This parameter is use hold Data in Dictionary format
        3.type-> This parameter have get or post type
    @result
*********************************************************************************************************************/
-(id)getCompleteRequestWithServiceName:(NSString*)serviceName params:(NSMutableDictionary*)params type:(RequestType)type
{
    NSURL *finalUrl ;
    if (serviceName) {
        finalUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,serviceName]];
        
    }else{
        finalUrl = [NSURL URLWithString:BASE_URL];
    }
    
    if (type == kPost) {
        return [self creatPostRequestWithURL:finalUrl params:params];
    }
    return [self creatGetRequestWithURL:finalUrl params:params];
}




/*********************************************************************************************************************
	@function	-creatPostRequestWithURL:
	@discussion	 This is instance method which is create post request.
	@param	This Method takes Two parameter
            1.url-> This parameter is hold the service URL
            2.params->This parameter is use hold Data in Dictionary format
    @result	return post request to calling method
*********************************************************************************************************************/

-(NSMutableURLRequest*)creatPostRequestWithURL:(NSURL*)url params:(NSMutableDictionary*)params
{
    NSMutableURLRequest *request;
    
    NSError *error;
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    request = [NSMutableURLRequest requestWithURL:url
                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                  timeoutInterval:720];
    [request setHTTPMethod:@"POST"];
    //    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}





/*********************************************************************************************************************
	@function	-creatGetRequestWithURL:
	@discussion	 This is instance method which is create get request.
	@param	This Method takes Two parameter
            1.url-> This parameter is hold the service URL
            2.params->This parameter is use hold Data in Dictionary format
    @result	return get request to calling method
*********************************************************************************************************************/

-(NSMutableURLRequest*)creatGetRequestWithURL:(NSURL*)url params:(NSMutableDictionary*)params
{
    NSString *urlString = [url absoluteString];
    urlString = [urlString stringByAppendingString:@"?"];
    
    NSMutableURLRequest *request;
    
    for (NSString *key in params)
    {
        
        urlString = [urlString stringByAppendingFormat:@"%@=%@&",key,[params objectForKey:key]];
    }
    
    urlString = [urlString substringToIndex:([urlString length] - 1)];
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *myURL = [[NSURL alloc] initWithString:urlString];
    request = [NSMutableURLRequest requestWithURL:myURL
                                      cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                  timeoutInterval:720];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return request;
}


@end
