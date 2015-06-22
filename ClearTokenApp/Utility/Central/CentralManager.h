//
//  CentralManager.h
//  ClearTokenApp
//
//  Created by Ravi Patel on 21/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BlueBlocks.h"
@class RKPeripheral;


@interface CentralManager : NSObject<CBPeripheralDelegate>
@property (atomic,strong,readonly) NSMutableArray * peripherals;
@property(readonly) CBCentralManagerState state;
@property (nonatomic,copy)ObjectChangedBlock onStateChanged;
- (instancetype) initWithQueue:(dispatch_queue_t)queue options:(NSDictionary *) options NS_AVAILABLE(NA, 7_0);
- (instancetype) initWithQueue:(dispatch_queue_t)queue;


//roushan
- (void)sendStatusCompletionBlock:(void(^)(int status))completion;




#pragma mark Scanning or Stopping Scans of Peripherals

- (void)scanForPeripheralsWithServices:(NSArray *)serviceUUIDs options:(NSDictionary *)options onUpdated:(PeripheralUpdatedBlock) onUpdate;

- (void)stopScan;

#pragma mark Establishing or Canceling Connections with Peripherals

- (void)connectPeripheral:(Peripheral *)peripheral options:(NSDictionary *)options onFinished:(PeripheralConnectionBlock) finished onDisconnected:(PeripheralConnectionBlock) disconnected;
- (void)cancelPeripheralConnection:(Peripheral *)peripheral onFinished:(PeripheralConnectionBlock) ondisconnected;
#pragma mark Retrieving Lists of Peripherals
- (NSArray *)retrieveConnectedPeripheralsWithServices:(NSArray *)serviceUUIDs NS_AVAILABLE(NA, 7_0);
- (NSArray *)retrievePeripheralsWithIdentifiers:(NSArray *)identifiers NS_AVAILABLE(NA, 7_0);

@end
