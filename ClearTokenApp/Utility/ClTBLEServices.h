//
//  ClTBLEServices.h
//  ClearTokenApp
//
//  Created by Ravi Patel on 15/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>
#import "Peripheral.h"
#import "CentralManager.h"
#import "Constant.h"





@protocol ClTBLEServicesDelegate <NSObject>

//These are delegate method

@optional
/*********************************************************************************
	@function	-didDiscoverDevice:
	@discussion	 This is delegate method of ClTBLEServicesDelegate protocal. This method called during the BLE Device searching mode
	@param This method take the Peripheral model call object.
	@result	 N/A
*********************************************************************************/

-(void)didDiscoverDevice:(Peripheral *) peripheral ;




/*********************************************************************************
	@function	-connectionStatus:
	@discussion	 This is delegate method of ClTBLEServicesDelegate protocal. This method called when the device is connect or disconnect and with the status.
	@param This method take the status which is indicate that device is connected or disconnect
	@result	 N/A
 ********************************************************************************/

-(void)connectionStatus:(NSString *)status;




/*********************************************************************************
	@function	-messageRecieveStatus:
	@discussion	 This is delegate method of ClTBLEServicesDelegate protocal. This method called ofter the sending the Message to BLE device.
	@param  Parameter hold the message status of BLE device.
	@result	 N/A
*********************************************************************************/

-(void)messageRecieveStatus:(NSString*)messageStatus;



/*********************************************************************************
    @function	-DidUpdateBTOnOffState:
    @discussion	 This is delegate method of ClTBLEServicesDelegate protocal. This method called when the bluetooth on/off on device
    @param  Parameter hold the on/off status.
    @result	 N/A
*********************************************************************************/

-(void)DidUpdateBTOnOffState:(bluetoothStatus)onOffStatus;

@end

@interface ClTBLEServices : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>
{

}



@property (nonatomic , weak) id <ClTBLEServicesDelegate> delegate;
@property (nonatomic,strong) Peripheral * selectedPeripheral;
@property (nonatomic,strong) CentralManager * central;

/*********************************************************************************
	@function	-sharedInstance:
	@discussion	 This is method create the sington instance of ClTBLEServices
	@param  N/A
	@result	 return the instance of ClTBLEServices class
*********************************************************************************/

+(ClTBLEServices*)sharedInstance;




/*********************************************************************************

	@function	-GetDeviceList:
	@discussion	 When call this method then implement the didDiscoverDevice delegate method which is Search the BLE devices give the peripheral model object.
	@param  N/A;
	@result	 N/A
*********************************************************************************/

-(void)getDeviceList;




/*********************************************************************************
	@function	-GetDeviceList:
	@discussion	 When call this method then implement the connectionStatus delegate method which is give the status of device connected or not.
	@param  This method take the peripheral as parameter;
	@result	 N/A
*********************************************************************************/

-(void)connectDevice:(Peripheral *)peripheral;




/*********************************************************************************
	@function	-sendMessageToDeviceWithPeripheral:
	@discussion	 This method send the message to BLE devices. When call this method then implement the messageRecieveStatus delegate method which is give the status of device recieve the message or not.
	@param  This method take two parameter on peripheral and another is device token;
	@result	 N/A
*********************************************************************************/

-(void)sendMessageToDeviceWithPeripheral:(Peripheral*)devicePeripheral andDeviceToken: (NSString *)deviceToken;




/*********************************************************************************
	@function	-disconnectDevice:
	@discussion	 This method disconnect the connected BLE device. When call this method then implement the messageRecieveStatus delegate method which is give the status of device connected or not.
	@param  This method take the peripheral as parameter;
	@result	 N/A 
*********************************************************************************/

-(void)disconnectDevice:(Peripheral *)peripheral;




/*********************************************************************************
	@function	-stopDeviceSeach:
	@discussion	 This method stop the searching of the BLE device.
	@param  N/A	
    @result	 N/A
*********************************************************************************/

-(void)stopDeviceSearch;




/*********************************************************************************
    @function	-DidUpdateState:
	@discussion	 This is instance method of the ClTBLEServices. This method called in CentralManager class during the bluetooth On/Off.
	@param  deviceStatus hold the value of the bluetooth On/Off status.
    @result	 N/A
 *********************************************************************************/
-(void)DidUpdateState:(bluetoothStatus)deviceStatus;


@end
