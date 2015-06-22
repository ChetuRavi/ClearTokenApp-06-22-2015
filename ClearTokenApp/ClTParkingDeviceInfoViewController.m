//
//  ClTParkingDeviceInfoViewController.m
//  ClearTokenApp
//
//  Created by HOME on 16/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import "ClTParkingDeviceInfoViewController.h"

#import  "ClTHomeViewController.h"
#import "ClTDataModel.h"
#import "ClTLoadingActivity.h"
#import "Utility.h"
#import "ClTBLEServices.h"
#import "PaymentSuccessViewController.h"




@interface ClTParkingDeviceInfoViewController ()<ClTDataModelDelegate,ClTBLEServicesDelegate>
{
    int stepperCounter;
    ClTDataModel *dataModel;
    BOOL blueToothOnoFFStatus;
}
@end

@implementation ClTParkingDeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"ResponceObject==%@",APP_DELEGATE.responceDataObject);
    blueToothOnoFFStatus=YES;
    //[self.labelSuccessPaymentMessage setHidden:YES];
    
    
    dataModel=[[ClTDataModel alloc]init];
    
    dataModel.delegate=self;
    
    [ClTBLEServices sharedInstance].delegate=self;
    
}



/*********************************************************************************
	@function	viewWillAppear:
	@discussion this method called before the setup the view so stop the ClTLoadingActivity indicator here and inslize the stepperCounter value from 1 and call the UpDateDeviceView method
    @param
	@result	
 *********************************************************************************/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[ClTLoadingActivity defaultAgent] makeBusy:NO];
    
    stepperCounter=1;
    [self UpdateDeviceView];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






#pragma markClTService Delegate method

/*********************************************************************************
	@function	UpDateDeviceView
	@discussion this method setup the view on deviceInfo screen.
 @param N/A
	@result
 ********************************************************************************/
-(void)UpdateDeviceView
{
    
    [self.activityImageDownloadStatus startAnimating];
    
    self.viewCanvas.backgroundColor=[Utility SetBackGroundColor:APP_DELEGATE.responceDataObject.stringDeviceId];
    
    self.labelDeviceID.text=APP_DELEGATE.responceDataObject.stringDeviceId;
    
    if ([APP_DELEGATE.responceDataObject.stringType isEqualToString:@"M"]) {
        self.labelType.text=@"Meter";
        [[self labelType] setFont:[UIFont boldSystemFontOfSize:25]];
    }
    
    self.labelMaxIncrements.text=[NSString stringWithFormat:@"$ %@ / %@ %@ \n %@ %@ Maximum",APP_DELEGATE.responceDataObject.numberFee,APP_DELEGATE.responceDataObject.stringIncrements,[Utility unitStringWithIncrements:APP_DELEGATE.responceDataObject.stringIncrements],APP_DELEGATE.responceDataObject.stringMaxIncrements,[Utility unitStringWithIncrements:APP_DELEGATE.responceDataObject.stringMaxIncrements]];
    
    self.labelLocation.text=APP_DELEGATE.responceDataObject.stringLocation;
    
    self.labelCharge.text=[NSString stringWithFormat:@"Charge=$ %d",[APP_DELEGATE.responceDataObject.numberFee intValue] * stepperCounter];
    
    //hide this field in V type
    
    if ([APP_DELEGATE.responceDataObject.stringType isEqualToString:@"V"]) {
        
        self.labelType.text=APP_DELEGATE.responceDataObject.stringOwnerID;
        [self.labelMaxIncrements setHidden:YES];
     
        [self.buttonMinus setHidden:YES];
        [self.buttonPlus setHidden:YES];
        [self.buttonPay setTitle:@"VEND" forState:UIControlStateNormal];
    }
    
    
    
    if (APP_DELEGATE.perpheralModelObject.state==2) {
        [self.buttonConnectDisconnect setTitle:@"DISCONNECT" forState:UIControlStateNormal];
    }
    else
    {
        [self.buttonConnectDisconnect setTitle:@"CONNECT" forState:UIControlStateNormal];
    }
    
    [dataModel getImageWithName:APP_DELEGATE.responceDataObject.stringPhotoFile];
    
}


/*********************************************************************************
	@function	-moveToPayment:
	@discussion	 This is instance methode
 @param  N/A
	@result	  create the instance of UIStoryboard and  push the PaymentSuccessViewController class
 *********************************************************************************/

-(void)moveToPayment
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PaymentSuccessViewController *paymentSuccessVC = (PaymentSuccessViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PaymentSuccessViewController"];
    paymentSuccessVC.stepperValue=stepperCounter;
    [self.navigationController pushViewController:paymentSuccessVC animated:YES];
}




#pragma mark Pay Button
/*********************************************************************************
	@function	buttonPayClick
	@discussion this method handle the event of button pay .
    @param N/A
	@result when called this method getDeviceTokenWithPhone method on ClTDataModel class which is takes four parameter
 *********************************************************************************/



- (IBAction)buttonPayClick:(id)sender {

    if ([self checkBlueToothOnOFFWithConnectionStatus]) {
        
       
            [[ClTLoadingActivity defaultAgent] makeBusy:YES];
  
        
            NSString *phoneNo = [[NSUserDefaults standardUserDefaults]
                                 stringForKey:@"PhoneNumber"];
            
            
            NSString *fee=[NSString stringWithFormat:@"%d",[APP_DELEGATE.responceDataObject.numberFee intValue] * stepperCounter] ;
            
            [dataModel getDeviceTokenWithPhone:phoneNo withDevice:APP_DELEGATE.responceDataObject.stringDeviceId withIncrements:self.labelStepperCurrentValue.text withFee:fee];
            
        }
}



/*********************************************************************************
 @function	-connectDisconnectClick:
	@discussion	 This method associated with buttonConnectDisconnect. This is handle the   connection between BLE device to mobile device.
 @param  N/A
	@result	 N/A
 *********************************************************************************/

- (IBAction)connectDisconnectClick:(id)sender {
    NSLog(@"CONNECTIONSTATUS==>%ld",(long)APP_DELEGATE.perpheralModelObject.state);
    
    
    if (blueToothOnoFFStatus) {
        
        
        if ( [self.buttonConnectDisconnect.titleLabel.text isEqualToString:@"DISCONNECT"]) {
            
            [[ClTBLEServices sharedInstance] disconnectDevice:APP_DELEGATE.perpheralModelObject];
        }
        
        else{
            
            [[ClTBLEServices sharedInstance] connectDevice:APP_DELEGATE.perpheralModelObject];
        }
    }
    else
    {[Utility showAlertMessage:@"Please turn on Bluetooth" withTitle:@"Error"];
        
    }
}






/*********************************************************************************
 @function	-checkBlueToothOnOFFWithConnectionStatus:
 @discussion	 This is instance method which is check the blueTooth is on/off statu and device is connected or disconnected.
 @param  N/A.
 @result	 N/A
 *********************************************************************************/
-(BOOL)checkBlueToothOnOFFWithConnectionStatus{
    if (blueToothOnoFFStatus) {
        
        if(APP_DELEGATE.perpheralModelObject.state==2)
        {
            return YES;
        }
        else
        {
            [Utility showAlertMessage:@"The Clear Token device is not connected, please check bluetooth and connect the device" withTitle:@"Status"];
            return NO;
        }
        
    }
    else
    {
        [Utility showAlertMessage:@"Please turn on Bluetooth" withTitle:@"Error"];
        return NO;
    }
    
}




#pragma mark Custom Stepper method

/*********************************************************************************
	@function	buttonPlusClick
	@discussion this method handle the event buttonPlus .
 @param N/A
	@result when called this method increaset the stepperCounter value and set on to labelStepperCurrentValue */
/*********************************************************************************/

- (IBAction)buttonPlusClick:(id)sender {
    if (stepperCounter<[APP_DELEGATE.responceDataObject.stringMaxIncrements intValue]) {
        stepperCounter++;
        self.labelStepperCurrentValue.text=[NSString stringWithFormat:@"%i", stepperCounter];
        self.labelCharge.text=[NSString stringWithFormat:@"Charge=$ %d",[APP_DELEGATE.responceDataObject.numberFee intValue] * stepperCounter];
        
    }
}





/*********************************************************************************
	@function	buttonMinusClick
	@discussion this method handle the event buttonPlus .
 @param N/A
	@result when called this method decreaset the stepperCounter value and set on to labelStepperCurrentValue
 *********************************************************************************/

- (IBAction)buttonMinusClick:(id)sender {
    
    if (stepperCounter>1) {
        stepperCounter--;
        self.labelStepperCurrentValue.text=[NSString stringWithFormat:@"%i", stepperCounter];
        self.labelCharge.text=[NSString stringWithFormat:@"Charge=$ %d",[APP_DELEGATE.responceDataObject.numberFee intValue] * stepperCounter];
        
    }
    
}







#pragma mark ClTBLEServices delegate

/*********************************************************************************
	@function	-messageRecieveStatus:
	@discussion	 messageRecieveStatus method is delegate method which is called ofter send the message to device
 @param take NSString as parameter for status method
	@result	  if the recieve the responce success then move to payment screen
 *********************************************************************************/

-(void)messageRecieveStatus:(NSString*)messageStatus
{
    NSLog(@"MessageStatus==%@",messageStatus);
    [self moveToPayment];
    
}



/*********************************************************************************
 @function	-DidUpdateBTOnOffState:
 @discussion	 This is delegate method which is called ofter the image download successfully.
 @param  This method hold the single parameter imagelogo.
	@result	 N/A
 
 *********************************************************************************/
-(void)DidUpdateBTOnOffState:(bluetoothStatus)onOffStatus{
    
    
    
    if (APP_DELEGATE.perpheralModelObject.state==2) {
        [self.buttonConnectDisconnect setTitle:@"DISCONNECT" forState:UIControlStateNormal];
    }
    else
    {
        [self.buttonConnectDisconnect setTitle:@"CONNECT" forState:UIControlStateNormal];
        //[self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
    blueToothOnoFFStatus=YES;
    [[ClTLoadingActivity defaultAgent] makeBusy:NO];
    if (onOffStatus==kOFF) {
        blueToothOnoFFStatus=NO;
        //  [Utility showAlertMessage:@"Please turn on Bluetooth" withTitle:@"Error"];
    }
    else
    {
        
    }
    
    }



/*********************************************************************************
 @function	-connectionStatus:
 @discussion	 This is delegate method which is hold the status of BLE device mobile device connected or not.
 @param  This method has take on parameter as status as string.
	@result	 N/A
 *********************************************************************************/

-(void)connectionStatus:(NSString *)status{
    
    NSLog(@"Status==%@",status);
    if([status isEqualToString:@"Connected"]){
        
        [self.buttonConnectDisconnect setTitle:@"DISCONNECT" forState:UIControlStateNormal];
        //[[ClTLoadingActivity defaultAgent] makeBusy:NO];
    }
    else
    {
        [self.buttonConnectDisconnect setTitle:@"CONNECT" forState:UIControlStateNormal];
    }
}




#pragma mark ClTDataModel delegate method

/*********************************************************************************
	@function	-successResponceToken:
	@discussion	 This is delegate method which is called ofter the recieve successfull responce from getDeviceTokenWithPhone method.
 @param This method has take two arguments one is ClTTokenModel class objected and is identifier.
 @result	  when the recieve the responce successfully then call  sendMessageToDeviceWithPeripheral for sending the token to BLE device
 *********************************************************************************/

-(void)successResponceToken:(ClTTokenModel *) responceTokenModel forServiceIdentifier :(ServiceIdentifier)identifer {
    
    NSLog(@"ResponceToken delegate call==%@",responceTokenModel.stringToken);
    
    //[[ClTBLEServices sharedInstance] sendComand:responceTokenModel.stringToken];
    
    [ClTBLEServices sharedInstance].delegate=self;
    [[ClTBLEServices sharedInstance] sendMessageToDeviceWithPeripheral:APP_DELEGATE.perpheralModelObject andDeviceToken:responceTokenModel.stringToken];
    
    }





/*********************************************************************************
	@function	-responseFailure:
	@discussion	 responseFailure method is delegate method which is called during the paring the data or getting  failer responce from services
 @param
	@result	  simply show the alert message ******************************************************************************/

-(void)responseFailure:(NSString *) errorResponce forServiceIdentifier :(ServiceIdentifier)identifer {
    
    [[ClTLoadingActivity defaultAgent] makeBusy:NO];
    [Utility showAlertMessage:errorResponce withTitle:@"Error"];
    NSLog(@"Responce Failuer call***********%@",errorResponce);
}




/**********************************************************************************
 @function	-successDownloadImage:
 @discussion	 This is delegate method which is called ofter the image download successfully.
 @param  This method hold the single parameter imagelogo.
	@result	 N/A
 **********************************************************************************/

-(void)successDownloadImage:(UIImage*)imagelogo{
    [self.imageViewLogo setImage:imagelogo];
    [self.activityImageDownloadStatus stopAnimating];
    
}






//


@end
