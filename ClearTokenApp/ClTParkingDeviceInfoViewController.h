//
//  ClTParkingDeviceInfoViewController.h
//  ClearTokenApp
//
//  Created by HOME on 16/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClTDeviceiInfoModel.h"
#import "Peripheral.h"
#import "ClTParkingDeviceInfoViewController.h"


@protocol ClTHomeViewDelegate <NSObject>

-(void)deviceDataFromHome:(NSDictionary *)deviceData;

@end

@interface ClTParkingDeviceInfoViewController : UIViewController

//labelDeviceID is show selected device id

@property (weak, nonatomic) IBOutlet UILabel *labelDeviceID;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewLogo;



//labelLocation id show the location of device which is getting by the responce data
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;

//labelType is show the device type like meter or vending device
@property (weak, nonatomic) IBOutlet UILabel *labelType;

//labelMaxIncrements is show the maxIncremetns on selected device
@property (weak, nonatomic) IBOutlet UILabel *labelMaxIncrements;

//labelCharge is show the parking charge
@property (weak, nonatomic) IBOutlet UILabel *labelCharge;
// buttonPay is handle the event of send the token to BLE device
@property (weak, nonatomic) IBOutlet UIButton *buttonPay;

//buttonPlus is increase the counter value
@property (weak, nonatomic) IBOutlet UIButton *buttonPlus;

//buttonMinus is decrease the counter value

@property (weak, nonatomic) IBOutlet UIButton *buttonMinus;

//view Cnavas is background view which is hold the all componets

@property (weak, nonatomic) IBOutlet UIView *viewCanvas;

//labelStepperCurrentValue show the counter current value
@property (weak, nonatomic) IBOutlet UILabel *labelStepperCurrentValue;


//labelStepper is hold the custom steper plus minus and labelStepperCurrentValue
@property (weak, nonatomic) IBOutlet UIView *viewCustomStepper;

@property (weak, nonatomic) IBOutlet UIButton *buttonConnectDisconnect;

@property (weak, nonatomic) IBOutlet UIImageView *activityImageDownloadStatus;




@end
