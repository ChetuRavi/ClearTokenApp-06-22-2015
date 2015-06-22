//
//  PaymentSuccessViewController.h
//  ClearTokenApp
//
//  Created by HOME on 17/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClTDeviceiInfoModel.h"
#import "Peripheral.h"

@interface PaymentSuccessViewController : UIViewController
{
    int stepperValue;
}



//labelDeviceID is show selected device id
@property (weak, nonatomic) IBOutlet UILabel *labelDeviceID;

//labelImage set the image if client provided
//@property (weak, nonatomic) IBOutlet UILabel *labelImage;


@property (weak, nonatomic) IBOutlet UIImageView *imageViewLogo;


//labelLocation id show the location of device which geting the responce data
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;

//labelType is show the device type like meter or vending device
@property (weak, nonatomic) IBOutlet UILabel *labelType;

//labelSuccessPaymentMessage show the confimation message
@property (weak, nonatomic) IBOutlet UILabel *labelSuccessPaymentMessage;

//view Cnavas is background view which is hold the all componets
@property (weak, nonatomic) IBOutlet UIView *viewCanvas;

//stepperValue use for calculating the price accoring to time
@property (assign, nonatomic) int stepperValue;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityImageDownloadStatus;










@end
