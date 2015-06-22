//
//  ClTPhoneViewController.m
//  ClearTokenApp
//
//  Created by Ravi Patel on 21/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import "ClTPhoneViewController.h"
#import "ClTDataModel.h"
#import "Utility.h"
#import "ClTLoadingActivity.h"

@interface ClTPhoneViewController ()<ClTDataModelDelegate>
{
    NSString *tempPhone;
    ClTDataModel *dataModelObject;
}

@end

@implementation ClTPhoneViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    rightDoneConst.priority=10;
    self.textFieldPhoneNo.placeholder=@"Enter Phone No";
    dataModelObject=[[ClTDataModel alloc]init];
    dataModelObject.delegate=self;
    
    phnWid.constant = 0.0;
    horzSpace.priority = UILayoutPriorityFittingSizeLevel;
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.labelHintMessage setHidden:YES];
    
}



/*********************************************************************************
 @function	-doneButtonClick:
 @discussion	 This is instance method which is associated with buttonDone. This button behave as the toggle button.This is hide and show the UI component according to the verification and taking phone no screen.
 @param	N/A.
 @result
 *********************************************************************************/

- (IBAction)doneButtonClick:(id)sender {
    
    
    if ([self.buttonDone.titleLabel.text isEqualToString:@"Verify"]) {
        
        [dataModelObject verifyNumberWithPhone:tempPhone andPin:self.textFieldPhoneNo.text];
        
    }
    if([self.buttonDone.titleLabel.text isEqualToString:@"Done"]){
        [[ClTLoadingActivity defaultAgent] makeBusy:YES];
        [dataModelObject requestForMessagePinWithPhone:self.textFieldPhoneNo.text];
        tempPhone=self.textFieldPhoneNo.text;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*********************************************************************************
 @function	-ResponceForPinRequest:
 @discussion	 This is delegate method which is hold the success responce for requesing the verification PIN.
 @param	 This method take two parameters one is store the responce data and another is store the identifer.
 @return	This method also handle some UI according to screen type
 *********************************************************************************/

-(void)ResponceForPinRequest:(NSString *) responceStatus forServiceIdentifier :(ServiceIdentifier)identifer
{
    NSLog(@"ResponcePinRequest=>%@",responceStatus);
    
    self.textFieldPhoneNo.text=nil;
    self.textFieldPhoneNo.placeholder=@"Enter verification code";
    [self.buttonDone setTitle:@"Verify" forState:UIControlStateNormal];
    phnWid.constant = 103;
    // horzSpace.priority = UILayoutPriorityDefaultHigh;
    rightDoneConst.priority=750;
    [self.labelHintMessage setHidden:NO];
    
    [[ClTLoadingActivity defaultAgent] makeBusy:NO];
}






/*********************************************************************************
 @function	-ResponceForVerifyPhoneNumber:
 @discussion	 This is delegate method which is hold the success responce for verification the phone no request.
 @param	 This method take two parameters one is store the responce data and another is store the identifer.
 @result	This method redirect to Home screen
 *********************************************************************************/

-(void)ResponceForVerifyPhoneNumber:(NSString *) responceStatus forServiceIdentifier :(ServiceIdentifier)identifer
{
    NSLog(@"ResponceVerification==%@",responceStatus);
    
    {
        //****** set the value in NSuser Default*******//
        
        [[NSUserDefaults standardUserDefaults] setObject:tempPhone forKey:@"PhoneNumber"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // [Utility showAlertMessage:@"Phone number store successfully" withTitle:@"Message"];
        //**********//
        [[ClTLoadingActivity defaultAgent] makeBusy:NO];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}






/*********************************************************************************
 @function	-responseFailure:
 @discussion	 This is delegate method which is hold the errorResponce  for  PIN request and verification Phone No request.
 @param	 This method take two parameters one is store the error Responce data and another is store the identifer.
 @result	 present alert message according to error value
 *********************************************************************************/

-(void)responseFailure:(NSString *) errorResponce forServiceIdentifier :(ServiceIdentifier)identifer
{
    [[ClTLoadingActivity defaultAgent] makeBusy:NO];
    NSLog(@"responseFailure==%@",errorResponce);
    
    if ([errorResponce isEqual:@"0"] && (identifer==kGetVerify)) {
        
        [Utility showAlertMessage:@"Wrong PIN.\nPlease try again." withTitle:@"Error"];
    }
    else if([errorResponce isEqualToString:@"PHONE_NUMBER_FORMAT_INVALID"]){
        
        [Utility showAlertMessage:@"Invalid phone No." withTitle:@"Error"];
    }
    else {
        
        [Utility showAlertMessage:errorResponce withTitle:@"Error"];
    }
   
}






/*********************************************************************************
 @function	-enterPhoneNoClick:
 @discussion	 This is instance method which is associated the Back Button.
 @param	 This method method hide the verification button and change the position of UI Components.
 @result
 *********************************************************************************/

- (IBAction)enterPhoneNoClick:(id)sender {
    
    // [self.buttonResendVerificationCode setHidden:YES];
    phnWid.constant = 0.0;
    horzSpace.priority = UILayoutPriorityFittingSizeLevel;
    self.textFieldPhoneNo.text=nil;
    self.textFieldPhoneNo.placeholder=@"Enter Phone No";
    [self.buttonDone setTitle:@"Done" forState:UIControlStateNormal];
    [self.labelHintMessage setHidden:YES];
    rightDoneConst.priority=10;
    
}





@end
