//
//  Beacon.h
//  beacontracker
//
//  Created by Lluis on 26/12/2014.
//  Copyright (c) 2014 Lluis Mora. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface Beacon : NSObject <MKOverlay>

@property (strong, nonatomic) NSString *name;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (strong, nonatomic) NSNumber *rssi;
@property (strong, nonatomic) NSDate *seen;
@property (strong, nonatomic) NSNumber *distance;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) MKMapRect boundingMapRect;

- (id) initWithName: (NSString *)transmitter RSSI: (NSNumber *)signal Date: (NSDate *)date AndCoordinate: (CLLocationCoordinate2D) coord;

+ (double) calculateAccuracyWithPower: (int) txPower AndRSSI: (double) rssi;

- (void)updateDetails:(Beacon *)beacon;

@end
