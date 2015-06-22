//
//  CITHomViewController.m
//  ClearTokenApp
//
//  Created by Ravi Patel on 15/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import "CITHomViewController.h"
#import "ClTHomeViewCell.h"
#import "ClTBLEServices.h"
#import "ClTParkingDeviceInfoViewController.h"
#import "ClTDataModel.h"
#import "Constant.h"
#import "FactoryViewController.h"
#import "ClTLoadingActivity.h"
#import "Utility.h"
#import "ClTPhoneViewController.h"

#import "CentralManager.h"
#import "BlueBlocks.h"
#import "BlueKit.h"
#import "NSData+Hex.h"
#import "AppDelegate.h"
#import "ClTUtility.h"

@interface CITHomViewController () <ClTBLEServicesDelegate,ClTDataModelDelegate>
{
    
}
//@property (nonatomic,strong) CentralManager * central;

@end


@implementation CITHomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"Home Screen";
    [self.tableViewDeviceList setTableFooterView:[UIView new]];
    
    
    
    
#pragma mark  Alloc Model class
    
    //        dataModel=[[ClTDataModel alloc]init];
    //        dataModel.delegate=self;
    
    //******PhoneViewController
    
    //
    //    NSString *phoneNo = [[NSUserDefaults standardUserDefaults]
    //                            stringForKey:@"preferenceName"];
    //
    
    
    //    if (!phoneNo) {
    //        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //        ClTPhoneViewController *phoneVC = (ClTPhoneViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ClTPhoneViewController"];
    //                     [self.navigationController presentViewController:phoneVC animated:NO completion:nil];
    //    }
    //
    /////////***********//
    
    //  else{
    
    
   // [[ClTLoadingActivity defaultAgent] makeBusy:NO];
    
    self.arrayDevices=[[NSMutableArray alloc]init ];
    
  //  [ClTBLEServices sharedInstance].delegate = self;
   // [[ClTBLEServices sharedInstance] GetDeviceList];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    [[ClTLoadingActivity defaultAgent] makeBusy:NO];
    
    [ClTBLEServices sharedInstance].delegate = self;
    if (self.arrayDevices.count>0) {
         [self.arrayDevices removeAllObjects];
    }
   
    [[ClTBLEServices sharedInstance] GetDeviceList];
}







/*!	@function	-numberOfRowsInSection:
	@discussion	 This is tableView data source method which is return the number of rows in section.
	@param
	@result	  */


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //return  _central.peripherals.count;
    return self.arrayDevices.count;
}









/*!	@function	-cellForRowAtIndexPath:
	@discussion	 This is tableview required delegate method whcih is create the tableview cell .
	@param
	@result	 tableview cell */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
    static NSString *CellIdentifier = @"cell";
    ClTHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ClTHomeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //    Peripheral * peripheral = _central.peripherals[indexPath.row] ;
    //    CBPeripheral * devicePer = peripheral.peripheral;
    
   // [self.arrayDevices objectAtIndex:indexPath.row];
    if (self.arrayDevices.count>indexPath.row) {
          NSString *yourString= [[self.arrayDevices objectAtIndex:indexPath.row] name];
        cell.backgroundColor=[Utility SetBackGroundColor:yourString];
        
        cell.labelDeviceName.text=yourString;

    }
  
    
    
    return cell;
}




// didSelectRowAtIndexPath is tableView delegate method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    _selectedPeripheral = self.arrayDevices[indexPath.row];
    NSString *DeviceID= _selectedPeripheral.peripheral.name;
    
    [[ClTLoadingActivity defaultAgent] makeBusy:YES];
    
    ClTDataModel *dataModel=[[ClTDataModel alloc]init];
    dataModel.delegate=self;
    [dataModel getDeviceInfoWithDevice:DeviceID];
    
}





//heightForRowAtIndexPath tableView delegate method which is return the hight of table cell

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}






#pragma mark ClTBLEServices delegate method

/*!	@function	-didDiscoverDevice:
	@discussion	 This is delegate method which is called during the searching BLE device
    @param This delegate method take the  Peripheral model class
	@result	   takes the peripheral model and find device and store the device name is array then reload the data of tableview */

-(void)didDiscoverDevice:(Peripheral *) peripheral {
    
    if (peripheral.name) {
        
        
        NSLog(@"deviceList==%@",peripheral.name);
        
        [self.arrayDevices addObject:peripheral];
        
        NSLog(@"arrayDevice==%@",self.arrayDevices);
        if (self.arrayDevices.count>0) {
             [self.tableView reloadData];
        }
       
    }
}






/*!	@function	-connectionStatus:
	@discussion	 This is delegate method which is called ofter the BLE device and iOS device are connected
	@param This delegate method take the  status
	@result	  called moveToPariking method which is present the parking   */

-(void)connectionStatus:(NSString *)status{
    
    NSLog(@"Status==%@",status);
    if([status isEqualToString:@"Connected"]){
       
        [self moveToParking:_deviceDataModel];
    }
    else
    {
        [ClTUtility showAlertMessage:status];
    }
}







#pragma mark ClTDataModel delegate method



/*!	@function	-successResponceDeviceInfo:
	@discussion	 This is delegate method which is called ofter the recieve successfull responce from getDeviceInfoWithDevice method.
 @param This method has take two arguments one is ClTDeviceiInfoModel class objected and is identifier.
 @result	  when the recieve the responce successfully then try to connect BLE device with iOS device  */

-(void)successResponceDeviceInfo:(ClTDeviceiInfoModel *) responceDataModel forServiceIdentifier :(ServiceIdentifier)identifer ;
{
    
    
   // [Utility sharedInstance].clTDeviceInfoModelObject = responceDataModel;
    APP_DELEGATE.responceDataObject=responceDataModel;
 NSLog(@"ResponceDeviceModel delegate call==%@", APP_DELEGATE.responceDataObject);
    
   // NSLog(@"[Utility sharedInstance].clTDeviceInfoModelObject   %@",[Utility sharedInstance].clTDeviceInfoModelObject);
    _deviceDataModel = responceDataModel;
    
    [[ClTBLEServices sharedInstance] connectDevice:_selectedPeripheral];
    
    
}





/*!	@function	-moveToParking:
	@discussion	 moveToParking method take one parameter and push the ClTParkingDeviceInfoViewController.
 @param This method has take one parameter of ClTDeviceiInfoModel
	@result	  This method create the storyboard object and push the ClTParkingDeviceInfoViewController class with assign responcedata to appdelegate property responceDataObject for global access these property in application  */

-(void)moveToParking:(ClTDeviceiInfoModel *)responceData
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ClTParkingDeviceInfoViewController *parkingInfoVC = (ClTParkingDeviceInfoViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ClTParkingDeviceInfoViewController"];
    // set value to appdelegate class
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    appDelegate.responceDataObject=responceData;
    appDelegate.selectedPerpheral=_selectedPeripheral;
    
    
    parkingInfoVC.responceDataObject = responceData;
    parkingInfoVC.selectedPerpheral = _selectedPeripheral;
    
    [self.navigationController pushViewController:parkingInfoVC animated:YES];
}



//-(void)successResponceToken:(ClTTokenModel *) responceTokenModel forServiceIdentifier :(ServiceIdentifier)identifer {
//
//     NSLog(@"ResponceToken delegate call==%@",responceTokenModel.stringToken);
//}








/*!	@function	-responseFailure:
	@discussion	 responseFailure method is delegate method which is called during the paring the data or getting  failer responce from services
 @param
	@result	  simply show the alert message  */

-(void)responseFailure:(NSMutableDictionary *) responseDictionary forServiceIdentifier :(ServiceIdentifier)identifer {
     [[ClTLoadingActivity defaultAgent] makeBusy:NO];
    [ClTUtility showAlertMessage:[responseDictionary valueForKey:@"error"]];
    NSLog(@"Responce Failuer call***********%@",responseDictionary);
    
    
}





/*!	@function -scanStopClick:
	@discussion	 scanStopClick method is instance method which is handle the event of buttonScanStop button
    @param
	@result	this method set the title on the buttonScanStop and show/hide the  activityIndicator called stopDeviceSeach and GetDeviceList method on ClTBLEServices  */

- (IBAction)scanStopClick:(id)sender {
    
    if ( [self.buttonScanStop.titleLabel.text isEqualToString:@"Stop"]) {
        
        [[ClTBLEServices sharedInstance] stopDeviceSeach];
        [self.activityIndicator stopAnimating];
        [self.activityIndicator setHidden:YES];
        [self.buttonScanStop setTitle:@"Scan" forState:UIControlStateNormal];
    }
    else{
        [self.buttonScanStop setTitle:@"Stop" forState:UIControlStateNormal];
        [self.activityIndicator setHidden:NO];
        [self.activityIndicator startAnimating];
        [[ClTBLEServices sharedInstance] GetDeviceList];
        [self.arrayDevices removeAllObjects];
    }
    
}



@end
