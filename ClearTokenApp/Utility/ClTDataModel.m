//
//  ClTDataModel.m
//  webServicesExample
//
//  Created by Ravi Patel on 12/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import "ClTDataModel.h"
#import "ClTWebservice.h"
#import "ClTDeviceiInfoModel.h"
#import "ClTTokenModel.h"

@implementation ClTDataModel

+(ClTDataModel*)sharedInstance{
    
    static ClTDataModel *sharedInstance = nil;
    static dispatch_once_t oncePedicate;
    dispatch_once(&oncePedicate, ^{
        
        sharedInstance = [[ClTDataModel alloc] init];
    });
    return sharedInstance;
}



/*********************************************************************************************************************
	@function	-getDeviceInfoWithDevice:
	@discussion	 This is instance method which is get the device information
 @param	Take the device id as a parameter in string format
	@result
 *********************************************************************************************************************/

-(void)getDeviceInfoWithDevice:(NSString *)deviceId{
    
    
    NSDictionary *infoParams=[[NSDictionary alloc]initWithObjectsAndKeys:deviceId,@"device",@"info",@"func", nil];
    
    
    [[ClTWebservice sharedInstance] callWebserviceWithServiceIdentifier:kGetDeviceInfo params:[infoParams mutableCopy] requestType:kGet Oncompletion:^(NSMutableDictionary *response) {
        
        
        [self  fillDeviceInfoModel:response  forServiceIdentifier:kGetDeviceInfo];
        
        
        
    }OnFailure:^(NSError *error) {
        if(self.delegate) {
            if([self.delegate respondsToSelector:@selector(responseFailure:forServiceIdentifier:)]) {
                [self.delegate responseFailure:error.localizedDescription forServiceIdentifier:kGetDeviceInfo];
            }
        }
        
    }nullResponse:^{
        if(self.delegate) {
            if([self.delegate respondsToSelector:@selector(responseFailure:forServiceIdentifier:)]) {
                [self.delegate responseFailure:NullResponceMessage forServiceIdentifier:kGetDeviceInfo];
            }
        }    }];
}



/*********************************************************************************************************************
	@function	-getDeviceTokenWithPhone:
	@discussion	 This is instance method which is take the device information for getting the device token
 @param	this method take the four parameter phoneNo, deviceId, increments and Fee. all parameter accept the NSString.
	@result
 *********************************************************************************************************************/

-(void)getDeviceTokenWithPhone:(NSString *)phone withDevice:(NSString *)device withIncrements:(NSString *)increments withFee:(NSString *) fee {
    
    NSDictionary *tokenParams=[[NSDictionary alloc]initWithObjectsAndKeys:phone,@"phone",device,@"device",increments,@"increments",fee,@"fee", nil];
    
    
    [[ClTWebservice sharedInstance] callWebserviceWithServiceIdentifier:kGetDeviceToken params:[tokenParams mutableCopy] requestType:kGet Oncompletion:^(NSMutableDictionary *response) {
        
        
        [self fillTokenModel:response forServiceIdentifier:kGetDeviceToken];
        
        
    }OnFailure:^(NSError *error) {
        if(self.delegate) {
            if([self.delegate respondsToSelector:@selector(responseFailure:forServiceIdentifier:)]) {
                [self.delegate responseFailure:error.localizedDescription forServiceIdentifier:kGetDeviceToken];
            }
        }
    }nullResponse:^{
        if(self.delegate) {
            if([self.delegate respondsToSelector:@selector(responseFailure:forServiceIdentifier:)]) {
                [self.delegate responseFailure:NullResponceMessage forServiceIdentifier:kGetDeviceToken];
            }
        }    }];
}





/*********************************************************************************************************************
	@function	-requestForMessagePinWithPhone:
	@discussion 	This is instance method which is take the phone number and request for Pin
 @param This method take the one parameter Phone number as string.
	@result
 *********************************************************************************************************************/

-(void)requestForMessagePinWithPhone:(NSString*)PhoneNumber
{
    
    NSDictionary *getPinParams=[[NSDictionary alloc]initWithObjectsAndKeys:PhoneNumber,@"phone",@"requestsms",@"func", nil];
    
    
    [[ClTWebservice sharedInstance] callWebserviceWithServiceIdentifier:kGetPin params:[getPinParams mutableCopy] requestType:kGet Oncompletion:^(NSMutableDictionary *response) {
        
        NSLog(@"requestForMessagePinWithPhone==%@",response);
        
        if([[response valueForKey:@"response"] isEqualToString:@"1"]){
            
            if(self.delegate) {
                if([self.delegate respondsToSelector:@selector(ResponceForPinRequest:forServiceIdentifier:)]) {
                    [self.delegate ResponceForPinRequest:[response valueForKey:@"response"] forServiceIdentifier:kGetPin];
                }
            }
        }
        
        else
        {
            if(self.delegate) {
                if([self.delegate respondsToSelector:@selector(responseFailure:forServiceIdentifier:)]) {
                    [self.delegate responseFailure:[response valueForKey:@"response"] forServiceIdentifier:kGetPin];
                }
            }
        }
        
        
        
        
    }OnFailure:^(NSError *error) {
        if(self.delegate) {
            if([self.delegate respondsToSelector:@selector(responseFailure:forServiceIdentifier:)]) {
                [self.delegate responseFailure:error.localizedDescription forServiceIdentifier:kGetPin];
            }
        }
    }nullResponse:^{
        if(self.delegate) {
            if([self.delegate respondsToSelector:@selector(responseFailure:forServiceIdentifier:)]) {
                [self.delegate responseFailure:NullResponceMessage forServiceIdentifier:kGetPin];
            }
        }    }];
    
    
}





/*********************************************************************************************************************
	@function	-verifyNumberWithPhone:
	@discussion 	This is instance method which is use for verifcation the phone number ofter recieved the pin
 @param This method take the two parameter one is Phone number and another is pin which is recieved by server.
	@result
 *********************************************************************************************************************/

-(void)verifyNumberWithPhone:(NSString *)phoneNumber andPin:(NSString *)pin{
    
    //    func=verifysms&phone=3033562800&code=1234
    NSDictionary *verifyPhoneNumber=[[NSDictionary alloc]initWithObjectsAndKeys:phoneNumber,@"phone",pin,@"code",@"verifysms",@"func", nil];
    
    
    [[ClTWebservice sharedInstance] callWebserviceWithServiceIdentifier:kGetVerify params:[verifyPhoneNumber mutableCopy] requestType:kGet Oncompletion:^(NSMutableDictionary *response) {
        if([[response valueForKey:@"response"] isEqualToString:@"1"]){
            
            if(self.delegate) {
                if([self.delegate respondsToSelector:@selector(ResponceForVerifyPhoneNumber:forServiceIdentifier:)]) {
                    [self.delegate ResponceForVerifyPhoneNumber:[response valueForKey:@"response"] forServiceIdentifier:kGetVerify];
                }
            }
        }
        
        else
        {
            
            if(self.delegate) {
                if([self.delegate respondsToSelector:@selector(responseFailure:forServiceIdentifier:)]) {
                    [self.delegate responseFailure:[response valueForKey:@"response"] forServiceIdentifier:kGetVerify];
                }
            }
        }
        
        
    }OnFailure:^(NSError *error) {
        if(self.delegate) {
            if([self.delegate respondsToSelector:@selector(responseFailure:forServiceIdentifier:)]) {
                [self.delegate responseFailure:error.localizedDescription forServiceIdentifier:kGetVerify];
            }
        }
    }nullResponse:^{
        if(self.delegate) {
            if([self.delegate respondsToSelector:@selector(responseFailure:forServiceIdentifier:)]) {
                [self.delegate responseFailure:NullResponceMessage forServiceIdentifier:kGetVerify];
            }
        }    }];
    
}






/*********************************************************************************************************************
	@function	fillDeviceInfoModel:
	@discussion 	This is instance method which is use to fill data in ClTDeviceiInfoModel class. These value getting from the server. Call the delegate method successResponceDeviceInfo: forServiceIdentifier.
 @param 1.responseDictionary: responseDictionary hold the device properties which is send by server.
 2.identifer: This parameter identify that calling service.
 *********************************************************************************************************************/

-(void)fillDeviceInfoModel:(NSDictionary*)responseDictionary  forServiceIdentifier :(ServiceIdentifier)identifer
{
    NSLog(@"FillDevice== %@",responseDictionary);
    
    ClTDeviceiInfoModel *deviceiInfoModel= [ClTDeviceiInfoModel sharedInstance];
    [deviceiInfoModel setStringCurrentStatus:[responseDictionary valueForKey:@"CurrentStatus"]];
    [deviceiInfoModel setStringDeviceId:[responseDictionary valueForKey:@"DeviceId"]];
    [deviceiInfoModel setNumberFee:[responseDictionary valueForKey:@"Fee"]];
    [deviceiInfoModel setStringIncrements:[responseDictionary valueForKey:@"Increments"]];
    [deviceiInfoModel setStringLatitude:[responseDictionary valueForKey:@"Latitude"]];
    [deviceiInfoModel setStringLocation:[responseDictionary valueForKey:@"Location"]];
    [deviceiInfoModel setStringLongitude:[responseDictionary valueForKey:@"Longitude"]];
    [deviceiInfoModel setStringMaxIncrements:[responseDictionary valueForKey:@"MaxIncrements"]];
    [deviceiInfoModel setStringOwnerID:[responseDictionary valueForKey:@"OwnerID"]];
    [deviceiInfoModel setStringPhotoFile:[responseDictionary valueForKey:@"PhotoFile"]];
    [deviceiInfoModel setStringType:[responseDictionary valueForKey:@"Type"]];
    [deviceiInfoModel setStringUnits:[responseDictionary valueForKey:@"Units"]];
    [deviceiInfoModel setStringZone:[responseDictionary valueForKey:@"Zone"]];
    if(self.delegate) {
        if([self.delegate respondsToSelector:@selector(successResponceDeviceInfo:forServiceIdentifier:)]) {
            [self.delegate successResponceDeviceInfo:deviceiInfoModel forServiceIdentifier:kGetDeviceInfo];
        }
    }
}



/*********************************************************************************************************************
	@function	fillTokenModel:
	@discussion 	This is instance method which is use to fill data in ClTTokenModel class. These value getting from the server. Call the delegate method successResponceToken: forServiceIdentifier.
 @param 1.responseDictionary: responseDictionary hold the device token which is send by server.
 2.identifer: This parameter identify that calling service.
 *********************************************************************************************************************/

-(void)fillTokenModel:(NSDictionary*)responseDictionary  forServiceIdentifier :(ServiceIdentifier)identifer
{
    NSLog(@"TokenModel ==%@",responseDictionary);
    
    ClTTokenModel *tokenModel=[ClTTokenModel sharedInstance];
    
    [tokenModel setStringToken:[responseDictionary valueForKey:@"response"]];
    
    
    
    if(self.delegate) {
        if([self.delegate respondsToSelector:@selector(successResponceToken:forServiceIdentifier:)]) {
            [self.delegate successResponceToken:tokenModel forServiceIdentifier:kGetDeviceToken];
        }
    }
    
}




/*********************************************************************************************************************
	@function	-getImageWithName:
	@discussion 	This is instance method which is use for download the imgage from server.
 @param  This method take one parameter imageName as string which is recieved by server.
	@result When download the image from server then called the delegate method successDownloadImage .
 *********************************************************************************************************************/
-(void)getImageWithName:(NSString*)imageName
{
    NSString *uRLasString=[[NSString stringWithFormat:@"http://www.cleartoken.com/appicons/%@.png",imageName] stringByReplacingOccurrencesOfString:@" "withString:@""];
    
    
    NSURL   *imageURL   = [NSURL URLWithString:uRLasString];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        
        
        NSData *data    = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image  = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(image) {
                
                
                if(self.delegate) {
                    if([self.delegate respondsToSelector:@selector(successDownloadImage:)]) {
                        [self.delegate successDownloadImage:image];
                    }
                }
                
            }
            else {
                
            }
            
            
        });
    });
    
}





@end
