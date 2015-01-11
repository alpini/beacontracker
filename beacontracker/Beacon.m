//
//  Beacon.m
//  beacontracker
//
//  Created by Lluis on 26/12/2014.
//  Copyright (c) 2014 Lluis Mora. All rights reserved.
//

#import "Beacon.h"

@implementation Beacon
@synthesize name;
@synthesize rssi;
@synthesize seen;
@synthesize distance;
@synthesize coordinate;
@synthesize boundingMapRect;
@synthesize title;
@synthesize subtitle;

- (id) initWithName: (NSString *)transmitter RSSI: (NSNumber *)signal Date: (NSDate *)date AndCoordinate: (CLLocationCoordinate2D) coord {
    self = [super init];
    
    if (self != nil) {
        self.name = transmitter;
        self.rssi = signal;
        self.seen = date;
        title = self.name;
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"HH:mm"];

        subtitle = [NSString stringWithFormat:@"Last seen at %@ (rssi: %@, distance: %@)", [dateFormat stringFromDate:seen], rssi, distance];

        coordinate = coord;
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:coord radius:[distance doubleValue]];
        boundingMapRect = [circle boundingMapRect];
    }

    return self;
}

- (void)updateDetails:(Beacon *)beacon {
    [self willChangeValueForKey:@"title"];
    title = [beacon.title copy];
    [self didChangeValueForKey:@"title"];

    [self willChangeValueForKey:@"subtitle"];
    subtitle = [beacon.subtitle copy];
    [self didChangeValueForKey:@"subtitle"];

    [self willChangeValueForKey:@"coordinate"];
    coordinate = beacon.coordinate;
    [self didChangeValueForKey:@"coordinate"];

    [self willChangeValueForKey:@"name"];
    name = [beacon.name copy];
    [self didChangeValueForKey:@"name"];

    [self willChangeValueForKey:@"rssi"];
    rssi = [beacon.rssi copy];
    [self didChangeValueForKey:@"rssi"];

    [self willChangeValueForKey:@"seen"];
    seen = [beacon.seen copy];
    [self didChangeValueForKey:@"seen"];

    [self willChangeValueForKey:@"boundingMapRect"];
    boundingMapRect = beacon.boundingMapRect;
    [self didChangeValueForKey:@"boundingMapRect"];
    
}

- (void)setRssi:(NSNumber *)signal {
    rssi = signal;

    double tmp = [Beacon calculateAccuracyWithPower:-50 AndRSSI:[self.rssi doubleValue]];
    self.distance = [NSNumber numberWithDouble:tmp];
}

// http://stackoverflow.com/questions/20416218/understanding-ibeacon-distancing/20434019#20434019
+ (double) calculateAccuracyWithPower: (int) txPower AndRSSI: (double) rssi {
    if (rssi == 0) {
        return -1.0; // if we cannot determine accuracy, return -1.
    }
    
    double ratio = rssi*1.0/txPower;
    if (ratio < 1.0) {
        return pow(ratio,10);
    }
    else {
        double accuracy =  (0.89976) * pow(ratio,7.7095) + 0.111;
        return accuracy;
    }
}

@end
