//
//  ClTBLEServices.m
//  ClearTokenApp
//
//  Created by Ravi Patel on 15/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import "ClTBLEServices.h"
#import "Constant.h"
#import "BlueKit.h"
#import "BlueBlocks.h"
#import "NSData+Hex.h"
#import "CentralManager.h"


@implementation ClTBLEServices




/*********************************************************************************
	@function	-sharedInstance:
	@discussion	 This is method create the sington instance of ClTBLEServices
	@param  N/A
	@result	 return the instance of ClTBLEServices class
 *********************************************************************************/

+(ClTBLEServices*)sharedInstance{
    
    static ClTBLEServices *sharedInstance = nil;
    static dispatch_once_t oncePedicate;
    dispatch_once(&oncePedicate, ^{
        
        sharedInstance = [[ClTBLEServices alloc] init];
    });
    return sharedInstance;
}





/*********************************************************************************
	@function	-stopDeviceSeach:
	@discussion	 This method stop the searching of the BLE device.
	@param  N/A
 @result	 N/A
 *********************************************************************************/

-(void)stopDeviceSearch{
    
    
    [self.central stopScan];
    
}




/*********************************************************************************
 
	@function	-GetDeviceList:
	@discussion	 When call this method then implement the didDiscoverDevice delegate method which is Search the BLE devices give the peripheral model object.
	@param  N/A;
	@result	 N/A
 *********************************************************************************/

-(void)getDeviceList
{
    NSDictionary * opts = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0)
    {
        opts = @{CBCentralManagerOptionShowPowerAlertKey:@YES};
    }
    self.central = [[CentralManager alloc] initWithQueue:nil options:opts];
    
    __weak ClTBLEServices * wp = self;
    
    if (self.central.state != CBCentralManagerStatePoweredOn)
    {
        self.central.onStateChanged = ^(NSError * error){
            
            [wp.central scanForPeripheralsWithServices:[NSArray arrayWithObject:[CBUUID UUIDWithString:@"c9cab9b8-3abf-4043-a5af-9ad00c6074d5"]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@NO}  onUpdated:^(Peripheral *peripheral) {
                
                if(wp.delegate) {
                    if([wp.delegate respondsToSelector:@selector(didDiscoverDevice:)]) {
                        [wp.delegate didDiscoverDevice:peripheral];
                    }
                }
                
                
                // [wp.tableViewDeviceList reloadData];
            }];
        };
        
    }
    //[_tableViewDeviceList reloadData];
}




/*********************************************************************************
	@function	-GetDeviceList:
	@discussion	 When call this method then implement the connectionStatus delegate method which is give the status of device connected or not.
	@param  This method take the peripheral as parameter;
	@result	 N/A
 *********************************************************************************/

-(void)connectDevice:(Peripheral *)peripheral{
    
    if(peripheral.state == CBPeripheralStateDisconnected)
    {
        
        [self.central connectPeripheral: peripheral options:nil onFinished:^(Peripheral * connectedperipheral, NSError *error) {
            if (!error)
            {
                
                //sussessfully connected device
                NSString *status=@"Connected";
                
                if(self.delegate) {
                    if([self.delegate respondsToSelector:@selector(connectionStatus:)]) {
                        [self.delegate connectionStatus:status];
                    }
                }
                
                
                
            }else
            {
                NSLog(@"connect failed");
                NSString *status=@"connectedFailed";
                if(self.delegate) {
                    if([self.delegate respondsToSelector:@selector(connectionStatus:)]) {
                        [self.delegate connectionStatus:status];
                    }
                }
                
            }
            
        } onDisconnected:^(Peripheral *connectedperipheral, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"disconnected");
                
                
                NSString *status=@"disconnected";
                if(self.delegate) {
                    if([self.delegate respondsToSelector:@selector(connectionStatus:)]) {
                        [self.delegate connectionStatus:status];
                    }
                }
                
            });
            
            
        }];
    }else
    {
        
    }
    
    
}



/*********************************************************************************
	@function	-sendMessageToDeviceWithPeripheral:
	@discussion	 This method send the message to BLE devices. When call this method then implement the messageRecieveStatus delegate method which is give the status of device recieve the message or not.
	@param  This method take two parameter on peripheral and another is device token;
	@result	 N/A
 *********************************************************************************/

-(void)sendMessageToDeviceWithPeripheral:(Peripheral*)devicePeripheral andDeviceToken: (NSString *)deviceToken
{
    __weak ClTBLEServices * this = self;
    
    this.selectedPeripheral=devicePeripheral;
    [devicePeripheral discoverServices:nil onFinish:^(NSError *error) {
        
        for (CBService * service in this.selectedPeripheral.services) {
            
            if ([service.UUID isEqual:[CBUUID UUIDWithString:DUUID]]) {
                
                [this.selectedPeripheral discoverCharacteristics:nil forService: service onFinish:^(CBService *service1, NSError *error) {
                    if (service1 == service)
                    {
                        for (CBCharacteristic * charst in service1.characteristics) {
                            
                            NSArray * property = [BlueKit propertiesFrom: charst.properties];
                            
                            if (property.count==2) {
                                
                                NSLog(@"%@",property);
                                
                                [this.selectedPeripheral discoverDescriptorsForCharacteristic:charst onFinish:^(CBCharacteristic *characteristic, NSError *error) {
                                    
                                    [this.selectedPeripheral setNotifyValue:YES forCharacteristic:charst onUpdated:^(CBCharacteristic *characteristic, NSError *error) {}];
                                    
                                    NSData * data = [NSData  dataWithHexString:deviceToken];
                                    
                                    CBCharacteristicWriteType type =CBCharacteristicWriteWithResponse;
                                    CharacteristicChangedBlock onfinish=nil;
                                    if ((charst.properties & CBCharacteristicPropertyWriteWithoutResponse) !=0)
                                    {
                                        type = CBCharacteristicWriteWithoutResponse;
                                    }else
                                    {
                                        
                                        onfinish = ^(CBCharacteristic * characteristic, NSError * error)
                                        {
                                            
                                            NSString *messageStatus=@"message sussefully send";
                                            if(self.delegate) {
                                                if([self.delegate respondsToSelector:@selector(messageRecieveStatus:)]) {
                                                    [self.delegate messageRecieveStatus:messageStatus];
                                                }
                                            }
                                            
                                            
                                            
                                            
                                            // [self moveToParking:_deviceDataModel];
                                        };
                                    }
                                    
                                    [this.selectedPeripheral writeValue:data forCharacteristic:charst type:type onFinish:onfinish];
                                    
                                    
                                    
                                    
                                }];
                                [this.selectedPeripheral readValueForCharacteristic:charst onFinish:^(CBCharacteristic *characteristic, NSError *error) {
                                    NSLog(@"%@",[charst.value hexadecimalString]);
                                }];
                            }
                        }
                    }
                }];
            }
        }
        NSLog(@"%@",_selectedPeripheral.services);
    }];
    
    
    
}




/*********************************************************************************
	@function	-disconnectDevice:
	@discussion	 This method disconnect the connected BLE device. When call this method then implement the messageRecieveStatus delegate method which is give the status of device connected or not.
	@param  This method take the peripheral as parameter;
	@result	 N/A
 *********************************************************************************/

-(void)disconnectDevice:(Peripheral *)peripheral
{
    
    [self.central cancelPeripheralConnection:peripheral onFinished:^(Peripheral * connectedperipheral, NSError *error) {
        if (!error)
        {
            NSLog(@"Device Disconnectd succssfully");
            
            NSString *status=@"disconnect";
            
            if(self.delegate) {
                if([self.delegate respondsToSelector:@selector(connectionStatus:)]) {
                    [self.delegate connectionStatus:status];
                }
            }
            
            
            
        }
    }];
}




/*********************************************************************************
 @function	-DidUpdateState:
	@discussion	 This is instance method of the ClTBLEServices. This method called in CentralManager class during the bluetooth On/Off.
	@param  deviceStatus hold the value of the bluetooth On/Off status.
 @result	 N/A
 *********************************************************************************/

-(void)DidUpdateState:(bluetoothStatus)deviceStatus
{
    // NSLog(@"DidUpdateState=%@",deviceStatus);
    
    if(self.delegate) {
        if([self.delegate respondsToSelector:@selector(DidUpdateBTOnOffState:)]) {
            [self.delegate DidUpdateBTOnOffState:deviceStatus];
        }
    }
    
    
}


@end
