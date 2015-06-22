//
//  PaymentSuccessViewController.m
//  ClearTokenApp
//
//  Created by HOME on 17/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import "PaymentSuccessViewController.h"
#import "Utility.h"
#import "ClTBLEServices.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "ClTLoadingActivity.h"
#import "ClTDataModel.h"

@interface PaymentSuccessViewController ()<ClTBLEServicesDelegate,ClTDataModelDelegate>

@end

@implementation PaymentSuccessViewController
@synthesize stepperValue=stepperValue;

/*********************************************************************************
    @function	viewDidLoad:
	@discussion Set the UI on success payment screen according to device Type(vending or parking).
    @param
	@result
*********************************************************************************/

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Payment Success";
    // Do any additional setup after loading the view.
    
    ClTDataModel *dataModelObject=[[ClTDataModel alloc]init];
    dataModelObject.delegate=self;
    
    self.viewCanvas.backgroundColor=[Utility SetBackGroundColor:APP_DELEGATE.responceDataObject.stringDeviceId];
    
    self.labelDeviceID.text=APP_DELEGATE.responceDataObject.stringDeviceId;
    self.labelLocation.text=APP_DELEGATE.responceDataObject.stringLocation;
    
    if ([APP_DELEGATE.responceDataObject.stringType isEqualToString:@"M"]) {
        self.labelType.text=@"Meter";
        [[self labelType] setFont:[UIFont boldSystemFontOfSize:25]];
    }
        
    if ([APP_DELEGATE.responceDataObject.stringType isEqualToString:@"V"]) {
        //self.labelType.text=@"Vending" ;
        self.labelType.text=APP_DELEGATE.responceDataObject.stringOwnerID;
    }
    // 
    NSDate *now = [NSDate date];
    NSDate *newDate = [now dateByAddingTimeInterval:[APP_DELEGATE.responceDataObject.stringIncrements intValue]*60*self.stepperValue]; // Add XXX seconds to *now
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"HH:mm";
    
    
    NSString *datestringofHour= [timeFormatter stringFromDate: newDate];
  
    self.labelSuccessPaymentMessage.text=[NSString stringWithFormat:@"$ %d has been charged to your account.\n You are paid until:%@",[APP_DELEGATE.responceDataObject.numberFee intValue]*stepperValue,datestringofHour];
    
    [dataModelObject getImageWithName:APP_DELEGATE.responceDataObject.stringPhotoFile];
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.activityImageDownloadStatus startAnimating];
    
}


/*********************************************************************************
 // Stop the LoadingActivity indicator
*********************************************************************************/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[ClTLoadingActivity defaultAgent] makeBusy:NO];
  }


/*********************************************************************************
 @function	-exitClick:
 @discussion	 This method associated with buttonDone and responsible for disconnecting the device connetion.
 @param N/A
 @result N/A
*********************************************************************************/

- (IBAction)exitClick:(id)sender {
    
    [ClTBLEServices sharedInstance].delegate = self;
    [[ClTBLEServices sharedInstance] disconnectDevice:APP_DELEGATE.perpheralModelObject ];
     exit(0);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark ClTBLEServices delegate method

/*********************************************************************************
	@function	-connectionStatus:
 @discussion	 This delegate method which is hold the status value of the connection status.If the disconnect the device then exit the application.
 @param N/A
 @result N/A
*********************************************************************************/

-(void)connectionStatus:(NSString *)status
{
    if ([status isEqualToString:@"disconnect"]) {
                    //exit(0);
        //     [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}



#pragma mark ClTDeviceiInfoModel delegate method


/*********************************************************************************
	@function	-successDownloadImage:
    @discussion	 This is delegate method which is hold the logo image.This method called ofter the request of getImageWithName: method
    @param N/A
    @result N/A
*********************************************************************************/

-(void)successDownloadImage:(UIImage*)imagelogo{
    [self.activityImageDownloadStatus stopAnimating];
    [self.imageViewLogo setImage:imagelogo];
}





@end
