//
//  CITHomeViewController.m
//  ClearTokenApp
//
//  Created by Ravi Patel on 15/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import "ClTHomeViewController.h"
#import "ClTHomeViewCell.h"
#import "ClTBLEServices.h"
#import "ClTParkingDeviceInfoViewController.h"
#import "ClTDataModel.h"
#import "Constant.h"
#import "ClTLoadingActivity.h"
#import "Utility.h"
#import "ClTPhoneViewController.h"
#import "CentralManager.h"
#import "AppDelegate.h"



@interface ClTHomeViewController () <ClTBLEServicesDelegate,ClTDataModelDelegate>
{
    BOOL blueToothOnoFFStatus;
    
}
//@property (nonatomic,strong) CentralManager * central;

@end


@implementation ClTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"Home";
    
    
#pragma mark  Alloc Model class
    
    
    //******Set HardCodded Phone NO ********//
    
    NSString *valueToSave = @"3035551212";
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"PhoneNumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //*******//
    
    NSString *phoneNo = [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"PhoneNumber"];
    
    
    //check the phone no store or not
    
    if (!phoneNo) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ClTPhoneViewController *phoneVC = (ClTPhoneViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ClTPhoneViewController"];
        [self.navigationController presentViewController:phoneVC animated:NO completion:nil];
    }
    //*********//
    
    
//    ClTBLEServices *bleService=[[ClTBLEServices alloc]init];
//    bleService.delegate=self;
    
    self.arrayDevices=[[NSMutableArray alloc]init ];
    
}
/*********************************************************************************
    @function	viewWillAppear:
	@discussion   In This method start the BLE device searching and set the text on navigation back button.
	@param
 *********************************************************************************/
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    [self.tableViewDeviceList setTableFooterView:[UIView new]];
    
    if ([self.tableViewDeviceList respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableViewDeviceList setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableViewDeviceList respondsToSelector:@selector(setLayoutMargins:)]) {
        // Safety check for below iOS 8
        [self.tableViewDeviceList setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    
    [[ClTLoadingActivity defaultAgent] makeBusy:NO];
    
    [ClTBLEServices sharedInstance].delegate = self;
    if (self.arrayDevices.count>0) {
        [self.arrayDevices removeAllObjects];
    }
    
    [[ClTBLEServices sharedInstance] getDeviceList];
    
    //set the back button
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];
    
    /******/
    
    [self performSelector:@selector(scanStopClick:) withObject:nil afterDelay:20];
    
}






/*********************************************************************************
	@function	-numberOfRowsInSection:
	@discussion	 This is tableView data source method which is return the number of rows in section.
	@param
	@result
 *********************************************************************************/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrayDevices.count;
}




/*********************************************************************************
 *********************************************************************************/
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}






/*********************************************************************************
 !	@function	-cellForRowAtIndexPath:
	@discussion	 This is tableview required delegate method whcih is create the tableview cell .
	@param
	@result	 tableview cell
 *********************************************************************************/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cell";
    ClTHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ClTHomeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (self.arrayDevices.count>indexPath.row) {
        NSString *yourString= [[self.arrayDevices objectAtIndex:indexPath.row] name];
        cell.backgroundColor=[Utility SetBackGroundColor:yourString];
        
        cell.labelDeviceName.text=yourString;
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



/*********************************************************************************
 didSelectRowAtIndexPath is tableView delegate method
 *********************************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (blueToothOnoFFStatus) {
        
        
        APP_DELEGATE.perpheralModelObject = self.arrayDevices[indexPath.row];
        NSString *DeviceID= APP_DELEGATE.perpheralModelObject.peripheral.name;
        
        [[ClTLoadingActivity defaultAgent] makeBusy:YES];
        
        ClTDataModel *dataModel=[[ClTDataModel alloc]init];
        dataModel.delegate=self;
        [dataModel getDeviceInfoWithDevice:DeviceID];
    }
    else
    {
        [Utility showAlertMessage:@"Please turn on Bluetooth" withTitle:@"Error"];
    }
}




/*********************************************************************************
 heightForRowAtIndexPath tableView delegate method which is return the hight of table cell
 *********************************************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}




/*********************************************************************************
	@function	-moveToParking:
	@discussion	 moveToParking method take one parameter and push the ClTParkingDeviceInfoViewController.
 @param This method has take one parameter of ClTDeviceiInfoModel
	@result	  This method create the storyboard object and push the ClTParkingDeviceInfoViewController class with assign responcedata to appdelegate property responceDataObject for global access these property in application
 *********************************************************************************/

-(void)moveToParking
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ClTParkingDeviceInfoViewController *parkingInfoVC = (ClTParkingDeviceInfoViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ClTParkingDeviceInfoViewController"];
    
    [self.navigationController pushViewController:parkingInfoVC animated:YES];
}




/*********************************************************************************
 
	@function -scanStopClick:
	@discussion	 scanStopClick method is instance method which is handle the event of buttonScanStop button
 @param
	@result	this method set the title on the buttonScanStop and show/hide the  activityIndicator called stopDeviceSeach and GetDeviceList method on ClTBLEServices
 *********************************************************************************/

- (IBAction)scanStopClick:(id)sender {
    if (blueToothOnoFFStatus) {
        
        if ( [self.buttonScanStop.titleLabel.text isEqualToString:@"Stop"]) {
            
            [[ClTBLEServices sharedInstance] stopDeviceSearch];
            [self.activityIndicator stopAnimating];
            [self.activityIndicator setHidden:YES];
            [self.buttonScanStop setTitle:@"Scan" forState:UIControlStateNormal];
        }
        else{
            
            [self.buttonScanStop setTitle:@"Stop" forState:UIControlStateNormal];
            [self.activityIndicator setHidden:NO];
            [self.activityIndicator startAnimating];
            [[ClTBLEServices sharedInstance] getDeviceList];
            [self.arrayDevices removeAllObjects];
            [self performSelector:@selector(scanStopClick:) withObject:nil afterDelay:20];
            
        }
    }
    else
    {
        
        [Utility showAlertMessage:@"Please turn on Bluetooth" withTitle:@"Error"];
        [self.arrayDevices removeAllObjects];
    }
}






#pragma mark ClTBLEServices delegate method
/*********************************************************************************
 
	@function	-didDiscoverDevice:
	@discussion	 This is delegate method which is called during the searching BLE device
 @param This delegate method take the  Peripheral model class
	@result	   takes the peripheral model and find device and store the device name is array then reload the data of tableview
 *********************************************************************************/

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





/*********************************************************************************
 
	@function	-connectionStatus:
	@discussion	 This is delegate method which is called ofter the BLE device and iOS device are connected
	@param This delegate method take the  status
	@result	  called moveToPariking method which is present the parking
 *********************************************************************************/

-(void)connectionStatus:(NSString *)status{
    
    NSLog(@"Status==%@",status);
    if([status isEqualToString:@"Connected"]){
        
        [self moveToParking];
    }
    else
    {
        [Utility showAlertMessage:@"The Clear Token device is not connected, please check bluetooth and connect the device" withTitle:@"Status"];
    }
}




/*********************************************************************************
 @function	-DidUpdateBTOnOffState:
 @discussion	 This is delegate method of ClTBLEServicesDelegate protocal. This method called when the bluetooth on/off on device
 @param  Parameter hold the on/off status.
 @result	 N/A
 *********************************************************************************/


-(void)DidUpdateBTOnOffState:(bluetoothStatus)onOffStatus{
    blueToothOnoFFStatus=YES;
    [[ClTLoadingActivity defaultAgent] makeBusy:NO];
    if (onOffStatus==kOFF) {
        [self scanStopClick:nil];
        blueToothOnoFFStatus=NO;
        // [Utility showAlertMessage:@"Please turn on Bluetooth" withTitle:@"Error"];
    }
    else
    {
        
    }
}




#pragma mark ClTDataModel delegate method


/*********************************************************************************
	@function	-successResponceDeviceInfo:
	@discussion	 This is delegate method which is called ofter the recieve successfull responce from getDeviceInfoWithDevice method.
 @param This method has hold two arguments one is ClTDeviceiInfoModel class object and is identifier.
 @result	  when the recieve the responce successfully then try to connect BLE device with iOS device
 *********************************************************************************/

-(void)successResponceDeviceInfo:(ClTDeviceiInfoModel *) responceDataModel forServiceIdentifier :(ServiceIdentifier)identifer ;
{
    APP_DELEGATE.responceDataObject=responceDataModel;
    NSLog(@"ResponceDeviceModel delegate call==%@", APP_DELEGATE.responceDataObject);
    
    
    [[ClTBLEServices sharedInstance] connectDevice:APP_DELEGATE.perpheralModelObject];
    
    
}












/*********************************************************************************
 
 @function	-responseFailure:
	@discussion	 responseFailure method is delegate method which is called during the paring the data or getting  failer responce from services
 @param
	@result	  simply show the alert message
 *********************************************************************************/

-(void)responseFailure:(NSString *) errorResponce forServiceIdentifier :(ServiceIdentifier)identifer {
    [[ClTLoadingActivity defaultAgent] makeBusy:NO];
    [Utility showAlertMessage:errorResponce withTitle:@"Error"];
    NSLog(@"Responce Failuer call***********%@",errorResponce);
    
    
}









@end
