//
//  CentralManager.m
//  ClearTokenApp
//
//  Created by Ravi Patel on 21/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import "CentralManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "Peripheral.h"
#import "ClTBLEServices.h"


@interface CentralManager()<CBCentralManagerDelegate>
@property (nonatomic,strong) CBCentralManager * manager;
@property (nonatomic,copy) PeripheralUpdatedBlock onPeripheralUpdated;

//@property (nonatomic,strong) NSArray * scanningServices;
//@property (nonatomic,strong) NSDictionary*  scanningOptions;
@property (nonatomic,assign) BOOL scanStarted;
@property (nonatomic,strong) NSMutableArray * connectingPeripherals;
@property (nonatomic,strong) NSMutableArray * connectedPeripherals;
@property (nonatomic,strong) NSDictionary * initializedOptions;
@property (nonatomic,strong) dispatch_queue_t queue;
@property (nonatomic,strong) NSMutableDictionary * disconnectedBlocks;
@property (nonatomic,strong) NSMutableDictionary * connectionFinishBlocks;
@end

@implementation CentralManager


/**************************************************************************************
 @function initializeWithQueue: queue
 @discussion This method alloc and initialize the array with dispatch_queue_t.
 @param 1.queue: The dispatch queue to use to dispatch the central role events.
 @result
 **************************************************************************************/
- (instancetype) initWithQueue:(dispatch_queue_t)queue
{
    self = [super init];
    if (self)
    {
        [self initializeWithQueue:queue options:nil];
    }
    return  self;
}


/**************************************************************************************
 @function initializeWithQueue: option
 @discussion This method alloc and initialize the array wiht default value.
 @param 1.queue: The dispatch queue to use to dispatch the central role events.
 2.options: define key for central manager.
 @result
  **************************************************************************************/
- (instancetype) initWithQueue:(dispatch_queue_t)queue options:(NSDictionary *) options
{
    self = [super init];
    if (self)
    {
        [self initializeWithQueue:queue options:options];
    }
    return  self;
}



/**************************************************************************************
 @function (instancetype) init
 @discussion This method initialize the array but options and Queue is set to nil values.
 **************************************************************************************/
- (instancetype) init
{
    self = [super init];
    if (self)
    {
        [self initializeWithQueue:nil options: nil];
    }
    return self;
}



/**************************************************************************************
 @function initializeWithQueue: option
 @discussion This method alloc and initialize the array wiht default value.
 @param 1.queue: The dispatch queue to use to dispatch the central role events.
        2.options: define key for central manager.
 @result
 **************************************************************************************/
- (void)initializeWithQueue:(dispatch_queue_t) queue options:(NSDictionary *) options
{
    self.queue = queue;
    self.initializedOptions = options;
    _peripherals = [[NSMutableArray alloc]init];
    self.connectingPeripherals = [[NSMutableArray alloc]init];
    self.connectedPeripherals = [[NSMutableArray alloc]init];
    self.connectionFinishBlocks = [[NSMutableDictionary alloc]init];
    self.disconnectedBlocks =  [[NSMutableDictionary alloc]init];
}



/**************************************************************************************
 @function (CBCentralManagerState)state
 @discussion Returns the current state of the central manager. (read-only)
 **************************************************************************************/

- (CBCentralManagerState)state
{
    return self.manager.state;
}




/**************************************************************************************
 @function (CBCentralManager *) manager
 @discussion Initializes the central manager with a specified delegate and dispatch queue.
 @param 1.delegate: The delegate to receive the central events.
        2.queue: The dispatch queue to use to dispatch the central role events. If the value is nil, the central manager dispatches central role events using the main queue.
 @return Returns a newly initialized central manager.
 **************************************************************************************/

- (CBCentralManager *) manager
{
    @synchronized(_manager)
    {
        if (!_manager)
        {
            if (![CBCentralManager instancesRespondToSelector:@selector(initWithDelegate:queue:options:)])
            {
                //for ios version lowser than 7.0
                self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:self.queue];
            }else
            {
                
                self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:self.queue options: self.initializedOptions];
            }
        }
    }
    return _manager;
}


- (void)dealloc
{
    _manager.delegate = nil;
}

#pragma mark Scanning or Stopping Scans of Peripherals

/**************************************************************************************
 @function scanForPeripheralsWithServices: options: onUpdated:
 @discussion Scans for peripherals that are advertising services.
 @param 1. serviceUUIDs: An array of CBUUID objects that the app is interested in. In this case, each CBUUID object represents the UUID of a service that a peripheral is advertising.
        2. options: An optional dictionary specifying options to customize the scan. For available options, see Peripheral Scanning Options.
 @result
 **************************************************************************************/

- (void)scanForPeripheralsWithServices:(NSArray *)serviceUUIDs options:(NSDictionary *)options onUpdated:(PeripheralUpdatedBlock) onUpdate
{
    NSAssert(onUpdate!=nil, @"onUpdate should be nil!");
    [self.manager scanForPeripheralsWithServices: serviceUUIDs options:options];
    self.onPeripheralUpdated = onUpdate;
}



/**************************************************************************************
 @function stopScan
 @discussion Asks the central manager to stop scanning for peripherals.
 @param
 @result
 **************************************************************************************/
- (void)stopScan
{
    [self.manager stopScan];
}


#pragma mark Establishing or Canceling Connections with Peripherals

/**************************************************************************************
 @function connectPeripheral: options: onFinished: onDisconnected:
 @discussion To connect the peripheral and add periphral to connectingPeripherals array.
 @param 1.peripheral: This is the instance of Peripheral model class.
        2.options: An optional dictionary specifying options to customize the scan.
        3.finished: This is PeripheralConnectionBlock refrence.
        4.disconnected: This is PeripheralConnectionBlock refrence.
 **************************************************************************************/

- (void)connectPeripheral:(Peripheral *)peripheral options:(NSDictionary *)options onFinished:(PeripheralConnectionBlock) finished onDisconnected:(PeripheralConnectionBlock) disconnected
{
    self.connectionFinishBlocks[peripheral.identifier] = finished;
    self.disconnectedBlocks[peripheral.identifier] = disconnected;
    [self.connectingPeripherals addObject: peripheral];
    [self.manager connectPeripheral: peripheral.peripheral options:options];
    
}


/**************************************************************************************
 @function cancelPeripheralConnection: onFinished:
 @discussion  Cancels an active or pending local connection to a peripheral.
 @param 1.peripheral: The peripheral to which the central manager is either trying to connect or has already connected.
 @result
 **************************************************************************************/

- (void)cancelPeripheralConnection:(Peripheral *)peripheral onFinished:(PeripheralConnectionBlock) ondisconnected
{
    self.disconnectedBlocks[peripheral.identifier] = ondisconnected;
    [self.manager cancelPeripheralConnection:peripheral.peripheral];
}




#pragma mark Retrieving Lists of Peripherals

//#: need to convert to Peripheral , with pre-delegate unchanged

/**************************************************************************************
 @function retrieveConnectedPeripheralsWithServices:
 @discussion Returns a list of the peripherals (containing any of the specified services) currently connected to the system.
 @param 1.serviceUUIDs: A list of service UUIDs (represented by CBUUID objects).
 @return A list of the peripherals that are currently connected to the system and that contain any of the services specified in the serviceUUID parameter.
 **************************************************************************************/




- (NSArray *)retrieveConnectedPeripheralsWithServices:(NSArray *)serviceUUIDs
{
    NSArray * t  =  [self.manager retrieveConnectedPeripheralsWithServices: serviceUUIDs];
    NSMutableArray * pers = [NSMutableArray arrayWithCapacity:t.count];
    for (CBPeripheral * peri in t)
    {
        Peripheral * per = peri.delegate;
        if (!per)
        {
            per = [[Peripheral alloc] initWithPeripheral:peri];
        }
        [pers addObject: per];
    }
    return pers;
}


/**************************************************************************************
 @function retrievePeripheralsWithIdentifiers:
 @discussion Returns a list of known peripherals by their identifiers.
 @param 1.identifiers: A list of peripheral identifiers (represented by NSUUID objects)        from which CBPeripheral objects can be retrieved.
 @result A list of peripherals that the central manager is able to match to the provided identifiers.
 **************************************************************************************/
- (NSArray *)retrievePeripheralsWithIdentifiers:(NSArray *)identifiers
{
    NSArray * t = [self.manager retrievePeripheralsWithIdentifiers:identifiers];
    NSMutableArray * pers = [NSMutableArray arrayWithCapacity:t.count];
    for (CBPeripheral * peri in t)
    {
        Peripheral * per = peri.delegate;
        if (!per)
        {
            per = [[Peripheral alloc] initWithPeripheral:peri];
        }
        [pers addObject: per];
    }
    return pers;
}



#pragma mark - internal methods

/**************************************************************************************
 @function clearPeripherals
 @discussion remove the all objects from array.
 @param N/A
 @result
 **************************************************************************************/

- (void)clearPeripherals
{
    [self.connectedPeripherals removeAllObjects];
    [self.connectingPeripherals removeAllObjects];
    [self.peripherals removeAllObjects];
    [self.connectionFinishBlocks removeAllObjects];
    [self.disconnectedBlocks removeAllObjects];
}




#pragma mark - Delegate
#pragma mark    central state delegate

/**************************************************************************************
 @function centralManagerDidUpdateState:
 @discussion Invoked when the central manager’s state is updated. (required)
 @param 1.central: The central manager whose state has changed.
 @result
 **************************************************************************************/

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central == self.manager)
    {
        
        switch ([central state])
        {
                
            case CBCentralManagerStatePoweredOff:
                
            {
                [[ClTBLEServices sharedInstance]DidUpdateState:kOFF];
                
                [self clearPeripherals];
                _onPeripheralUpdated(nil);
                break;
            }
                
            case CBCentralManagerStateUnauthorized:
            {
                /* Tell user the app is not allowed. */
                break;
            }
                
            case CBCentralManagerStateUnknown:
            {
                /* Bad news, let's wait for another event. */
                break;
            }
                
            case CBCentralManagerStatePoweredOn:
            {
                [[ClTBLEServices sharedInstance]DidUpdateState:kOn];
                if (_onPeripheralUpdated)
                {
                    _onPeripheralUpdated(nil);
                }
                
                break;
            }
                
            case CBCentralManagerStateResetting:
            {
                [self clearPeripherals];
                _onPeripheralUpdated(nil);
                break;
            }
            case CBCentralManagerStateUnsupported:
                break;
        }
        if (_onStateChanged)
        {
            _onStateChanged(nil);
        }
        
    }
   }


#pragma mark discovery delegate

/**************************************************************************************
 @function centralManager: didDiscoverPeripheral: advertisementData: RSSI:
 @discussion Invoked when the central manager discovers a peripheral while scanning.
 @param 1.central: The central manager providing the update.
 2.peripheral: The discovered peripheral.
 3.advertisementData: A dictionary containing any advertisement data.
 4.RSSI: The current received signal strength indicator (RSSI) of the peripheral, in decibels.
 @result
 **************************************************************************************/

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral1
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
   
    for ( Peripheral * tempPeripheral in self.peripherals) {
        
        if ([tempPeripheral.name isEqualToString:peripheral1.name]) {
            return;
           
        }
    }
    
    Peripheral * peripheral=peripheral1.delegate;
    if (!peripheral)
    {
        peripheral = [[Peripheral alloc] initWithPeripheral:peripheral1];
    }
    if (peripheral && ![self.peripherals containsObject: peripheral])
    {
        [self.peripherals addObject: peripheral];
    }
    peripheral.RSSI = RSSI;
    
    _onPeripheralUpdated(peripheral);
    
   
    
}

#pragma mark Monitoring Connections with Peripherals

/**************************************************************************************
 @function centralManager: didConnectPeripheral:
 @discussion Invoked when a connection is successfully created with a peripheral.
 @param 1.central: The central manager providing this information.
 2.peripheral: The peripheral that has been connected to the system.
 @result
 **************************************************************************************/

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    Peripheral * thePeripheral = peripheral.delegate;
    if (thePeripheral && [self.connectingPeripherals containsObject: thePeripheral])
    {
        PeripheralConnectionBlock finish = self.connectionFinishBlocks[thePeripheral.identifier];
        // remove it
        [self.connectingPeripherals removeObject: thePeripheral];
        [self.connectedPeripherals addObject: thePeripheral];
        if (finish)
        {
            finish(thePeripheral,nil);
            [self.connectionFinishBlocks removeObjectForKey: thePeripheral.identifier];
        }
        
    }
    
}



/**************************************************************************************
 @function centralManager: didFailToConnectPeripheral: error:
 @discussion Invoked when the central manager fails to create a connection with a peripheral.
 @param 1.central: The central manager providing this information.
 2.peripheral: The peripheral that failed to connect.
 3.error: The cause of the failure.
 @result
 **************************************************************************************/

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    Peripheral * thePeripheral = peripheral.delegate;
   
    if (thePeripheral&& [self.connectingPeripherals containsObject: thePeripheral])
    {
        PeripheralConnectionBlock finish = self.connectionFinishBlocks[thePeripheral.identifier];
        // remove it
        [self.connectingPeripherals removeObject: thePeripheral];
        if (finish)
        {
            finish(thePeripheral,error);
            [self.connectionFinishBlocks removeObjectForKey: thePeripheral.identifier];
            [self.disconnectedBlocks removeObjectForKey:thePeripheral.identifier];
        }
    }
    
}


/**************************************************************************************
 @function centralManager: didDisconnectPeripheral: error:
 @discussion Invoked when an existing connection with a peripheral is torn down.
 @param 1.central: The central manager providing this information.
        2.peripheral: The peripheral that has been disconnected.
        3.error: If an error occurred, the cause of the failure.
 @result
 **************************************************************************************/

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral1 error:(NSError *)error
{
    Peripheral * peripheral = peripheral1.delegate;
   
    if (peripheral && [self.connectedPeripherals containsObject: peripheral])
    {
        PeripheralConnectionBlock finish = self.disconnectedBlocks[peripheral.identifier];
        [self.connectedPeripherals removeObject:peripheral];
        if (finish)
        {
            finish(peripheral,error);
            [self.disconnectedBlocks removeObjectForKey:peripheral.identifier];
        }
    }
    

}

@end
