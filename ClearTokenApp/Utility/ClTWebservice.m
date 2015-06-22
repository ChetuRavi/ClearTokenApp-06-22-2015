//
//  ClTWebservice.m
//
//
//  Created by Chetu on 12/05/15.
//  Copyright (c) 2015 Chetu. All rights reserved.
//

#import "ClTWebservice.h"
#import "NSURLRequest+ClTWebservice.h"
//#import "ClTLoadingActivity.h"
#import "ClTUtility.h"
@implementation ClTWebservice

//*******************************************
// SHARED INSTANCE
//*******************************************


+(ClTWebservice*)sharedInstance{
    
    static ClTWebservice *sharedInstance = nil;
    static dispatch_once_t oncePedicate;
    dispatch_once(&oncePedicate, ^{
        
        sharedInstance = [[ClTWebservice alloc] init];
    });
    return sharedInstance;
}

- (void)callWebserviceWithServiceIdentifier:(ServiceIdentifier)serviceIdentifier params:(NSMutableDictionary *)params requestType:(RequestType)requestType Oncompletion:(OnSuccess)successBlock OnFailure:(OnFailure)failureBlock nullResponse:(OnNullResponse)nullResponse{
    
    if ([ClTUtility  checkNetworkStatus] == NO) {
        nullResponse();
        return;
    }
    
    // [self startNetworkActivityIndicator:serviceIdentifier];
    
    NSMutableURLRequest *finalRequest = nil;
    
    
    
    finalRequest = [[[NSURLRequest alloc] init] getCompleteRequestWithServiceName:@"" params:params type:requestType];
    
    [NSURLConnection sendAsynchronousRequest:finalRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        //        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if(error != nil) {
            
            
            failureBlock(error);
        }
        else
        {
            if (data) {
                
                NSError *error;
                
                NSMutableDictionary *response;
                NSString *responseToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                if (serviceIdentifier==kGetDeviceInfo) {
                    
                    response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
           

                    
                }
                if (serviceIdentifier==kGetDeviceToken||serviceIdentifier==kGetPin || serviceIdentifier==kGetVerify ) {
                    response=[[NSMutableDictionary alloc]initWithObjectsAndKeys:responseToken,@"response", nil];
                   

                }
                
                
                if ([response isKindOfClass:[NSDictionary class]] )  {
                    
                    successBlock(response);
                }
                
                if (!response){
                    nullResponse();
                }
                else{
                    response=nil;
                }
                
            }  else {
                
                nullResponse();
            }
        }
    }];
}

-(void)startNetworkActivityIndicator:(ServiceIdentifier)serviceIdentifier {
    //        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    
    
}



@end
