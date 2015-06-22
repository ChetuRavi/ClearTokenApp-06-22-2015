//
//  BlueBlocks.h
//  ClearTokenApp
//
//  Created by Ravi Patel on 21/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#ifndef ble_utility_RKBlueBlocks_h
#define ble_utility_RKBlueBlocks_h
#import <CoreBluetooth/CoreBluetooth.h>
//#pragma mark block defs
@class Peripheral;

// central manager
typedef void(^CharacteristicChangedBlock)(CBCharacteristic * characteristic, NSError * error);
typedef void(^DescriptorChangedBlock)(CBDescriptor * descriptor, NSError * error);
typedef void(^SpecifiedServiceUpdatedBlock)(CBService * service,NSError * error);
typedef void(^ObjectChangedBlock)(NSError * error);
typedef void(^ServicesUpdated)(NSArray * services);
typedef void(^PeripheralUpdatedBlock)(Peripheral * peripheral);
typedef void(^PeripheralConnectionBlock)(Peripheral * peripheral,NSError * error);

#endif
