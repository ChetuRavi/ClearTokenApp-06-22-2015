//
//  CITHomViewController.h
//  ClearTokenApp
//
//  Created by Ravi Patel on 15/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Peripheral.h"
#import "ClTDeviceiInfoModel.h"



@interface CITHomViewController : UITableViewController

//tableViewDeviceList show the list of available devices ofter search the device.

@property (strong, nonatomic) IBOutlet UITableView *tableViewDeviceList;

//arrayDevices hold the available devices list
@property (strong, nonatomic) NSMutableArray *arrayDevices;

//selectedPeripheral is model class which is hold the all infomation device selected BLE device
@property (nonatomic,strong) Peripheral * selectedPeripheral;

//deviceDataModel is a moddel class which is hold the property about the device which is send by server
@property(nonatomic,strong)ClTDeviceiInfoModel * deviceDataModel;

//buttonScanStop is handl the event scan and stop the BLE device search
@property (weak, nonatomic) IBOutlet UIButton *buttonScanStop;

//activityIndicator is showing the BLE device status for searching or stop  
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
