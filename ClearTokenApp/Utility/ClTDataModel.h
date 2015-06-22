//
//  ClTDataModel.h
//  webServicesExample
//
//  Created by Ravi Patel on 12/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
#import "ClTDataModel.h"
#import "ClTDeviceiInfoModel.h"
#import "ClTTokenModel.h"


@protocol ClTDataModelDelegate <NSObject>

@optional


/*********************************************************************************
	@function	-successResponceDeviceInfo:
	@discussion	This  Delegate method called ofter request for device information  successfuly
	@param	This method has take two parameter first is ClTDeviceiInfoModel and another is service Identifier.
	@result
*********************************************************************************/

-(void)successResponceDeviceInfo:(ClTDeviceiInfoModel *) responceDataModel forServiceIdentifier :(ServiceIdentifier)identifer ;





/*********************************************************************************
	@function	-successResponceToken:
	@discussion	This  Delegate method called ofter request for device token call successfuly
	@param	This method has take two parameter first is ClTTokenModel class object and another is service Identifier.
	@result	 
*********************************************************************************/

-(void)successResponceToken:(ClTTokenModel *) responceTokenModel forServiceIdentifier :(ServiceIdentifier)identifer ;





/*********************************************************************************
	@function	-ResponceForPinRequest:
	@discussion	 This  Delegate method which is hold the responce of Pin request service. 
    @param	This method has take two parameter first is responceStatus as a string format and another is service Identifier.
	@result N/A
 *********************************************************************************/

-(void)ResponceForPinRequest:(NSString *) responceStatus forServiceIdentifier :(ServiceIdentifier)identifer ;




/*********************************************************************************
	@function	-ResponceForVerifyPhoneNumber:
	@discussion	 This is Delegate method which is hold the responce For verifyNumberWithPhone request.
    @param 1.responceStatus: NSMutableDictionary hold the status of verifyNumberWithPhone request.
            2.identifer: This parameter identify that calling service.
 *********************************************************************************/

-(void)ResponceForVerifyPhoneNumber:(NSMutableDictionary *) responceStatus forServiceIdentifier :(ServiceIdentifier)identifer ;



/*********************************************************************************
	@function	-successDownloadImage:
	@discussion	 This is Delegate method which is hold the logo image as responce which is requested by getImageWithName: instance method.
    @param 1.imagelogo: imagelogo hold the logo image which is send by server.
 
 *********************************************************************************/
-(void)successDownloadImage:(UIImage*)imagelogo;



/*********************************************************************************************************************
	@function	-responseSuccess:
	@discussion	This is Delegate method called when the any error on responce data
	@param	This method has take two parameter first parameter contaion error code and another is service Identifier.
	@result	
 *********************************************************************************************************************/

-(void)responseFailure:(NSString *) errorResponce forServiceIdentifier :(ServiceIdentifier)identifer ;

@end

@interface ClTDataModel : NSObject
@property (nonatomic , weak) id <ClTDataModelDelegate> delegate;

+(ClTDataModel*)sharedInstance;

/*********************************************************************************************************************
	@function	-getDeviceInfoWithDevice:
	@discussion	 This is instance method which is get the device information
    @param	Take the device id as a parameter in string format
	@result
*********************************************************************************************************************/

-(void)getDeviceInfoWithDevice:(NSString *)deviceId;




/*********************************************************************************************************************
	@function	-getDeviceTokenWithPhone:
	@discussion	 This is instance method which is take the device information for getting the device token
    @param	this method take the four parameter phoneNo, deviceId, increments and Fee. all parameter accept the NSString.
	@result
*********************************************************************************************************************/

-(void)getDeviceTokenWithPhone:(NSString *)phone withDevice:(NSString *)device withIncrements:(NSString *)increments withFee:(NSString *) fee ;



/*********************************************************************************************************************
	@function	-requestForMessagePinWithPhone:
	@discussion 	This is instance method which is take the phone number and request for Pin
    @param This method take the one parameter Phone number as string.
	@result
 *********************************************************************************************************************/
-(void)requestForMessagePinWithPhone:(NSString*)PhoneNumber;




/*********************************************************************************************************************
	@function	-verifyNumberWithPhone:
	@discussion 	This is instance method which is use for verifcation the phone number ofter recieved the pin
    @param This method take the two parameter one is Phone number and another is pin which is recieved by server.
	@result
 *********************************************************************************************************************/

-(void)verifyNumberWithPhone:(NSString *)phoneNumber andPin:(NSString *)pin;



/*********************************************************************************************************************
	@function	-getImageWithName:
	@discussion 	This is instance method which is use for download the imgage from server.
    @param  This method take one parameter imageName as string which is recieved by server.
	@result When download the image from server then called the delegate method successDownloadImage .
 *********************************************************************************************************************/
-(void)getImageWithName:(NSString*)imageName;

@end
