//
//  AppDelegate.h
//  beacontracker
//
//  Created by Lluis on 21/12/2014.
//  Copyright (c) 2014 Lluis Mora. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreBluetooth;
#import <FYX/FYX.h>
#import <FYX/FYXSightingManager.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, FYXServiceDelegate, FYXSightingDelegate, CBCentralManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) CBCentralManager* bluetoothManager;
- (void)detectBluetooth;
- (void)centralManagerDidUpdateState:(CBCentralManager *)central;

@end

