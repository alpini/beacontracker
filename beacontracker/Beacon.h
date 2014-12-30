//
//  Beacon.h
//  beacontracker
//
//  Created by Lluis on 26/12/2014.
//  Copyright (c) 2014 Lluis Mora. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Beacon : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *rssi;
@property (strong, nonatomic) NSDate *seen;

@end
