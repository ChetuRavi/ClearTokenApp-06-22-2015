//
//  Peripheral.m
//  ClearTokenApp
//
//  Created by Ravi Patel on 21/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import "Peripheral.h"
#import "BlueBlocks.h"
@interface Peripheral()<CBPeripheralDelegate>
@property (nonatomic,copy) ObjectChangedBlock didFinishServiceDiscovery;
@property (nonatomic,copy)ObjectChangedBlock rssiUpdated;
@property (nonatomic,strong) NSMutableDictionary * servicesFindingIncludeService;
@property (nonatomic,strong) NSMutableDictionary * characteristicsDiscoveredBlocks;
@property (nonatomic,strong) NSMutableDictionary * descriptorDiscoveredBlocks;
@property (nonatomic,strong) NSMutableDictionary * characteristicsValueUpdatedBlocks;
@property (nonatomic,strong) NSMutableDictionary * descriptorValueUpdatedBlocks;
@property (nonatomic,strong) NSMutableDictionary * characteristicValueWrtieBlocks;
@property (nonatomic,strong) NSMutableDictionary * descriptorValueWrtieBlocks;
@property (nonatomic,strong) NSMutableDictionary * characteristicsNotifyBlocks;
@end

@implementation Peripheral



/***********************************************************************************************************************
	@function	-initWithPeripheral:
    @discussion	 This method initialize the required class with default value.
    @param	This method take CBPeripheral class object as parameter.
    @result return the instance of Peripheral
***********************************************************************************************************************/

- (instancetype)initWithPeripheral:(CBPeripheral *) peripheral
{
    self = [super init];
    if (self)
    {
        _peripheral = peripheral;
        _peripheral.delegate = self;
        //#callbacks for finding included services of specified service
        self.servicesFindingIncludeService = [NSMutableDictionary dictionaryWithCapacity:5];
        //
        self.characteristicsDiscoveredBlocks = [NSMutableDictionary dictionaryWithCapacity:5];
        self.descriptorDiscoveredBlocks = [NSMutableDictionary dictionaryWithCapacity:5];
        //# read value callbacks
        self.characteristicsValueUpdatedBlocks =[NSMutableDictionary dictionaryWithCapacity:5];
        self.descriptorValueUpdatedBlocks  =[NSMutableDictionary dictionaryWithCapacity:5];
        //# write value callbacks
        self.characteristicValueWrtieBlocks =[NSMutableDictionary dictionaryWithCapacity:5];
        self.descriptorValueWrtieBlocks =[NSMutableDictionary dictionaryWithCapacity:5];
        
        //#for characteristics notification
        self.characteristicsNotifyBlocks = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return self;
}



#pragma mark propertys

/***********************************************************************************************************************
	@function	-name:
 @discussion	 This method retun the name of peripheral device.
 @param N/A
 @result N/A
***********************************************************************************************************************/

- (NSString *)name
{
    if (!_name)
    {
        self.name = _peripheral.name;
    }
    return _name;
}




/*********************************************************************************************************************
	@function	-identifier:
    @discussion	 This method retun the identifier(NSUUID) of device.
    @param N/A
    @result N/A
 *******************************************************************************************************************/

- (NSUUID*)identifier
{
    if (!_identifier)
    {
        @try {
            self.identifier = _peripheral.identifier;
        }
        @catch (NSException *exception) {
            // ios6
            NSString * uuidStr =_peripheral.identifier.UUIDString;
            self.identifier = [[NSUUID alloc] initWithUUIDString: uuidStr];
            NSLog(@"solved");
        }
        @finally
        {
            
        }
    }
    return _identifier;
}




/***********************************************************************************************************************
	@function	-RSSI:
    @discussion	Returns a number, in decibels, that indicates the RSSI of the peripheral while it is currently connected to the central manager.
    @param N/A
    @result N/A
**********************************************************************************************************************/

- (NSNumber *)RSSI
{
    if (!_RSSI)
    {
        self.RSSI = self.peripheral.RSSI;
    }
    return _RSSI;
}



/**************************************************************************************
 @function	-state:
 @discussion	Returns The current connection state of the peripheral.
 @param N/A
 @result N/A
 ***************************************************************************************/

- (CBPeripheralState )state
{
    return self.peripheral.state;
}




/**************************************************************************************
 @function	-isEqual:
 @discussion	Returns The current connection state of the peripheral.
 @param N/A
 @result N/A 
**************************************************************************************/

- (BOOL)isEqual:(id)object
{
    return [self.peripheral isEqual: [object peripheral]];
}



#pragma mark discovery services

/**************************************************************************************
	@function	-discoverServices:onFinish
	@discussion	This  method convert the data to hexadecimalString
	@param	 serviceUUIDs-> Here, each CBUUID object represents a UUID that identifies the type of a characteristic you want to discover.
	@result	 N/A 
**************************************************************************************/

 - (void)discoverServices:(NSArray *)serviceUUIDs onFinish:(ObjectChangedBlock) discoverFinished
{
    NSAssert(discoverFinished!=nil, @"block finished must'not be nil!");
    self.didFinishServiceDiscovery = discoverFinished;
    [_peripheral discoverServices:serviceUUIDs];
}





/**************************************************************************************
	@function	-discoverIncludedServices:forService
	@discussion	 the peripheral returns only the included services of the service that      app is interested in
	@param	includedServiceUUIDs-> includedServiceUUIDs object represents a UUID that identifies the type of included service you want to discover.
            service->The service whose included services want to discover.
	@result	 N/A
**************************************************************************************/

- (void)discoverIncludedServices:(NSArray *)includedServiceUUIDs forService:(CBService *)service onFinish:(SpecifiedServiceUpdatedBlock) finished
{
    NSAssert(finished!=nil, @"block finished must'not be nil!");
    _servicesFindingIncludeService[service.UUID]=finished;
    [_peripheral discoverIncludedServices: includedServiceUUIDs forService:service];
}


/**************************************************************************************
    Services method return the peripheral services property as NSArray
 **************************************************************************************/

- (NSArray*)services
{
    return _peripheral.services;
}


#pragma mark Discovering Characteristics and Characteristic Descriptors
/**************************************************************************************
    @function discoverCharacteristics
	@discussion  Discovers the specified characteristics of a service.
	@param This method take characteristicUUIDs and service as parameter.
        1.characteristicUUIDs: each CBUUID object represents a UUID that identifies the type of a characteristic you want to discover.
        2.service: The service whose characteristics  want to discover
    @result
**************************************************************************************/

- (void)discoverCharacteristics:(NSArray *)characteristicUUIDs forService:(CBService *)service onFinish:(SpecifiedServiceUpdatedBlock) onfinish
{
    NSAssert(onfinish!=nil, @"block onfinish must'not be nil!");
    _characteristicsDiscoveredBlocks[service.UUID] = onfinish;
    [_peripheral discoverCharacteristics: characteristicUUIDs forService:service];
}



/**************************************************************************************
    @function discoverDescriptorsForCharacteristic: onFinish:
	@discussion Discovers the descriptors of a characteristic.
	@param characteristic: The characteristic whose descriptors want to discover
    @result

**************************************************************************************/

- (void)discoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic onFinish:(CharacteristicChangedBlock) onfinish
{
    NSAssert(onfinish!=nil, @"block onfinish must'not be nil!");
    _descriptorDiscoveredBlocks[characteristic.UUID] = onfinish;
    [_peripheral discoverDescriptorsForCharacteristic: characteristic];
}




#pragma mark Reading Characteristic and Characteristic Descriptor Values

/**************************************************************************************
    @function readValueForCharacteristic: onFinish:
	@discussion Retrieves the value of a specified characteristic.
	@param characteristic: The characteristic whose value want to read.
    @result
**************************************************************************************/

- (void)readValueForCharacteristic:(CBCharacteristic *)characteristic onFinish:(CharacteristicChangedBlock) onUpdate
{
    NSAssert(onUpdate!=nil, @"block onUpdate must'not be nil!");
    _characteristicsValueUpdatedBlocks[characteristic.UUID] = onUpdate;
    [_peripheral readValueForCharacteristic: characteristic];
}




/**************************************************************************************
    @function readValueForDescriptor: onFinish:
	@discussion Retrieves the value of a specified characteristic descriptor.
	@param descriptor: The characteristic descriptor whose value want to read.
    @result
**************************************************************************************/

- (void)readValueForDescriptor:(CBDescriptor *)descriptor onFinish:(DescriptorChangedBlock) onUpdate
{
    NSAssert(onUpdate!=nil, @"block onUpdate must'not be nil!");
    _descriptorValueUpdatedBlocks[descriptor.UUID] = onUpdate;
    [_peripheral readValueForDescriptor: descriptor];
}



#pragma mark Writing Characteristic and Characteristic Descriptor Values

/**************************************************************************************
    @function writeValue: forCharacteristic: type: onFinish:
	@discussion Writes the value of a characteristic
	@param  1.data: The value to be written.
            2.characteristic: The characteristic whose value is to be written.
            3.type: The type of write to be executed. For a list of the possible types of writes to a characteristic’s value, see Characteristic Write Types.
    @result
**************************************************************************************/

- (void)writeValue:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type onFinish:(CharacteristicChangedBlock) onfinish
{
    
    if (type == CBCharacteristicWriteWithResponse)
    {
        NSAssert(onfinish!=nil, @"block onfinish must'not be nil!");
        _characteristicValueWrtieBlocks[characteristic.UUID] = onfinish;
    }
    [_peripheral writeValue:data forCharacteristic:characteristic type: type];
}





/**************************************************************************************
    @function writeValue:forDescriptor:onFinish:
	@discussion Writes the value of a characteristic descriptor.
	@param 1.data: The value to be written.
            2.descriptor: The descriptor whose value is to be written.

    @result
 **************************************************************************************/

- (void)writeValue:(NSData *)data forDescriptor:(CBDescriptor *)descriptor onFinish:(DescriptorChangedBlock) onfinish
{
    if (onfinish)
    {
        _descriptorValueWrtieBlocks[descriptor.UUID] = onfinish;
    }
    [_peripheral writeValue:data forDescriptor:descriptor];
}




#pragma mark Setting Notifications for a Characteristic’s Value

/**************************************************************************************
    @function setNotifyValue: forCharacteristic: onUpdated:
	@discussion Sets notifications or indications for the value of a specified characteristic.
	@param 
        1.enabled: A Boolean value indicating whether wish to receive notifications or indications whenever the characteristic’s value changes. YES if want to enable notifications or indications for the characteristic’s value. NO if do not want to receive notifications or indications whenever the characteristic’s value changes.
        2.characteristic: The specified characteristic.
    @result
 **************************************************************************************/

- (void)setNotifyValue:(BOOL)enabled forCharacteristic:(CBCharacteristic *)characteristic onUpdated:(CharacteristicChangedBlock) onUpdated
{
    if (enabled)
    {
        NSAssert(onUpdated!=nil, @"block onUpdated must'not be nil!");
        self.characteristicsNotifyBlocks[characteristic.UUID] = onUpdated;
    }else
    {
        [self.characteristicsNotifyBlocks removeObjectForKey: characteristic.UUID];
    }
    [_peripheral setNotifyValue:enabled forCharacteristic:characteristic];
}




#pragma mark ReadRSSI

/**************************************************************************************
    @function readRSSIOnFinish:
	@discussion Retrieves the current RSSI value for the peripheral while it is connected to the central manager.
	@param onUpdated is block ObjectChangedBlock.
    @result

 **************************************************************************************/

- (void)readRSSIOnFinish:(ObjectChangedBlock) onUpdated
{
    self.rssiUpdated = onUpdated;
    [_peripheral readRSSI];
}



#pragma mark - Delegate
#pragma mark service discovery

/**************************************************************************************
    @function peripheral: didDiscoverServices:
	@discussion Invoked when you discover the peripheral’s available services.
	@param 1.peripheral: The peripheral that the services belong to.
            2.error: If an error occurred, the cause of the failure.

 @result
 **************************************************************************************/

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (peripheral == _peripheral)
    {
        self.didFinishServiceDiscovery(error);
        self.didFinishServiceDiscovery = nil;
    }
    //DebugLog(@"%p & %p",peripheral,_peripheral);
}




/**************************************************************************************
 @function peripheral: didDiscoverIncludedServicesForService: error:
	@discussion Invoked when you discover the included services of a specified service.
	@param 1.peripheral: The peripheral providing this information.
            2.service: The CBService object containing the included service.
            3.error: If an error occurred, the cause of the failure.
 @result
 **************************************************************************************/

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error
{
    if (peripheral == _peripheral)
    {
        SpecifiedServiceUpdatedBlock onfound = _servicesFindingIncludeService[service.UUID];
        if (onfound)
        {
            onfound(service,error);
            [_servicesFindingIncludeService removeObjectForKey:service.UUID];
        }
    }
}
#pragma mark Characteristics

/**************************************************************************************
 @function peripheral: didDiscoverCharacteristicsForService: error:
	@discussion Invoked when you discover the characteristics of a specified service.
	@param 1.peripheral: The peripheral providing this information.
            2.service: The service that the characteristics belong to.
            3.error: If an error occurred, the cause of the failure.
    @result
 **************************************************************************************/

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (peripheral == _peripheral)
    {
        SpecifiedServiceUpdatedBlock onfound = _characteristicsDiscoveredBlocks[service.UUID];
        if (onfound)
        {
            onfound(service,error);
            [_characteristicsDiscoveredBlocks removeObjectForKey: service.UUID];
        }
    }
}




/**************************************************************************************
 @function peripheral: didDiscoverDescriptorsForCharacteristic: error:
	@discussion Invoked when you discover the descriptors of a specified characteristic.
	@param 1.peripheral: The peripheral providing this information.
            2.characteristic: The characteristic that the characteristic descriptors belong to.
            3.error: If an error occurred, the cause of the failure.
 @result
 **************************************************************************************/


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (peripheral == _peripheral)
    {
        CharacteristicChangedBlock onfound = _descriptorDiscoveredBlocks[characteristic.UUID];
        if (onfound)
        {
            onfound(characteristic,error);
            [_descriptorDiscoveredBlocks removeObjectForKey: characteristic.UUID];
        }
    }
}




#pragma mark Retrieving Characteristic and Characteristic Descriptor Values

/**************************************************************************************
    @function peripheral: didUpdateValueForCharacteristic: error:
	@discussion Invoked when retrieve a specified characteristic’s value, or when the peripheral device notifies your app that the characteristic’s value has changed.
	@param 1.peripheral: The peripheral providing this information.
            2.characteristic: The characteristic whose value has been retrieved.
            3.error: If an error occurred, the cause of the failure.
    @result
 **************************************************************************************/

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (peripheral == _peripheral)
    {
        CharacteristicChangedBlock onupdate = _characteristicsValueUpdatedBlocks[characteristic.UUID];
        if (onupdate)
        {
            onupdate(characteristic,error);
            [_characteristicsValueUpdatedBlocks removeObjectForKey: characteristic.UUID];
        }else
        {
            //notifications
            onupdate = self.characteristicsNotifyBlocks[characteristic.UUID];
            if (onupdate)
            {
                onupdate(characteristic,error);
            }
        }

    }
}




/**************************************************************************************
 @function peripheral: didUpdateValueForDescriptor: error:
	@discussion Invoked when retrieve a specified characteristic descriptor’s value.
	@param 1.peripheral: The peripheral providing this information.
            2.descriptor: The characteristic descriptor whose value has been retrieved.
            3.error: If an error occurred, the cause of the failure.
 @result
 **************************************************************************************/

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    if (peripheral == _peripheral)
    {
        DescriptorChangedBlock onupdate = _descriptorValueUpdatedBlocks[descriptor.UUID];
        if (onupdate)
        {
            onupdate(descriptor,error);
            [_descriptorValueUpdatedBlocks removeObjectForKey:descriptor.UUID];
        }
    }
}






#pragma mark Writing Characteristic and Characteristic Descriptor Values

/**************************************************************************************
    @function peripheral: didWriteValueForCharacteristic: error:
	@discussion Invoked when write data to a characteristic’s value.
	@param 1.peripheral: The peripheral providing this information.
            2.characteristic: The characteristic whose value has been written.
            3.error: If an error occurred, the cause of the failure.
    @result
 **************************************************************************************/

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (peripheral == _peripheral)
    {
        CharacteristicChangedBlock onwrote = _characteristicValueWrtieBlocks[characteristic.UUID];
        if (onwrote)
        {
            onwrote(characteristic,error);
            [_characteristicValueWrtieBlocks removeObjectForKey:characteristic.UUID];
        }
    }
}



/**************************************************************************************
    @function peripheral: didWriteValueForDescriptor: error:
	@discussion Invoked when you write data to a characteristic descriptor’s value.
	@param 1.peripheral: The peripheral providing this information.
            2.descriptor: The characteristic descriptor whose value has been written.
            3.error: If an error occurred, the cause of the failure.
    @result
 **************************************************************************************/

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    if (peripheral == _peripheral)
    {
        DescriptorChangedBlock onwrote = _descriptorValueWrtieBlocks[descriptor.UUID];
        if (onwrote)
        {
            onwrote(descriptor,error);
            [_descriptorValueWrtieBlocks removeObjectForKey:descriptor.UUID];
        }

    }
}


#pragma mark Managing Notifications for a Characteristic’s Value

/**************************************************************************************
 @function peripheral: didUpdateNotificationStateForCharacteristic: error:
	@discussion Invoked when the peripheral receives a request to start or stop providing notifications for a specified characteristic’s value.
	@param  1.peripheral: The peripheral providing this information.
            2.characteristic: The characteristic for which notifications of its value are to be configured.
            3.error: If an error occurred, the cause of the failure.
 @result
 **************************************************************************************/

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (peripheral == _peripheral && self.notificationStateChanged)
    {
        self.notificationStateChanged(characteristic,error);
    }
}




#pragma mark Retrieving a Peripheral’s Received Signal Strength Indicator (RSSI) Data

/**************************************************************************************
 @function peripheralDidUpdateRSSI: error:
 @discussion Invoked when retrieve the value of the peripheral’s current RSSI while it is connected to the central manager.
 @param 1.peripheral: The peripheral providing this information.
        2.error: If an error occurred, the cause of the failure.
 @result
 **************************************************************************************/

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (peripheral == _peripheral)
    {
        self.RSSI = self.peripheral.RSSI;
        self.rssiUpdated(error);
        self.rssiUpdated = nil;
    }
    
}




#pragma mark Monitoring Changes to a Peripheral’s Name or Services

/**************************************************************************************
 @function peripheral: didModifyServices:
 @discussion: Invoked when a peripheral’s services have changed.
 @param 1.peripheral: The peripheral providing this information.
        2.invalidatedServices: A list of services that have been invalidated.
 @result
 **************************************************************************************/

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray *)invalidatedServices
{
    if (peripheral == _peripheral && self.onServiceModified)
    {
        self.onServiceModified(invalidatedServices);
    }
}




/**************************************************************************************
 @function peripheralDidUpdateName
 @discussion Invoked when a peripheral’s name changes.
 @param 1.peripheral: The peripheral providing this information.
 @result
 **************************************************************************************/

- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral
{
    if (peripheral == _peripheral && self.onNameUpdated)
    {
        self.onNameUpdated(nil);
    }
}


- (void)dealloc
{
    _peripheral.delegate = nil;
}
@end
