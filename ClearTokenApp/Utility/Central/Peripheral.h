//
//  Peripheral.h
//  ClearTokenApp
//
//  Created by Ravi Patel on 21/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BlueBlocks.h"

@interface Peripheral : NSObject
@property (nonatomic,strong,readonly) CBPeripheral * peripheral;
@property (nonatomic) NSArray * services;
@property(nonatomic,strong) NSUUID *identifier;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSNumber *RSSI;
@property (readonly) CBPeripheralState state;
@property (nonatomic,copy) ServicesUpdated onServiceModified;
@property (nonatomic,copy) ObjectChangedBlock onNameUpdated;
@property (nonatomic,copy) CharacteristicChangedBlock notificationStateChanged;
@property (nonatomic,copy)PeripheralConnectionBlock onConnectionFinished;
@property (nonatomic,copy)PeripheralConnectionBlock onDisconnected;
- (instancetype)initWithPeripheral:(CBPeripheral *) peripheral;

#pragma mark discovery services

- (void)discoverServices:(NSArray *)serviceUUIDs onFinish:(ObjectChangedBlock) discoverFinished;
- (void)discoverIncludedServices:(NSArray *)includedServiceUUIDs forService:(CBService *)service onFinish:(SpecifiedServiceUpdatedBlock) finished;

#pragma mark Discovering Characteristics and Characteristic Descriptors

- (void)discoverCharacteristics:(NSArray *)characteristicUUIDs forService:(CBService *)service onFinish:(SpecifiedServiceUpdatedBlock) onfinish;
- (void)discoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic onFinish:(CharacteristicChangedBlock) onfinish;

#pragma mark Reading Characteristic and Characteristic Descriptor Values

- (void)readValueForCharacteristic:(CBCharacteristic *)characteristic onFinish:(CharacteristicChangedBlock) onUpdate;
- (void)readValueForDescriptor:(CBDescriptor *)descriptor onFinish:(DescriptorChangedBlock) onUpdate;

#pragma mark Writing Characteristic and Characteristic Descriptor Values
- (void)writeValue:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type onFinish:(CharacteristicChangedBlock) onfinish;
- (void)writeValue:(NSData *)data forDescriptor:(CBDescriptor *)descriptor onFinish:(DescriptorChangedBlock) onfinish;

#pragma mark Setting Notifications for a Characteristic’s Value

- (void)setNotifyValue:(BOOL)enabled forCharacteristic:(CBCharacteristic *)characteristic onUpdated:(CharacteristicChangedBlock) onUpdated;

#pragma mark ReadRSSI

- (void)readRSSIOnFinish:(ObjectChangedBlock) onUpdated;
@end
