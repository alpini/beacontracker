//
//  AppDelegate.m
//  beacontracker
//
//  Created by Lluis on 21/12/2014.
//  Copyright (c) 2014 Lluis Mora. All rights reserved.
//

#import "AppDelegate.h"
#import  <FYX/FYX.h>
#import <FYX/FYXLogging.h>
#import <FYX/FYXTransmitter.h>
#import "Beacon.h"
#import "ViewController.h"

@import MapKit;
@import CoreBluetooth;

@interface AppDelegate ()
@property (nonatomic) FYXSightingManager *sightingManager;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"gmbl_hide_bt_power_alert_view"]; // This does not seem to work
    
    [self detectBluetooth];
    
    [FYXLogging setLogLevel:FYX_LOG_LEVEL_VERBOSE];
    [FYX disableLocationUpdates];
    [FYX setAppId:@"1336253af77323d4c4784e1f94387f9e76694fbe48139087005d3771fc9cb924" appSecret:@"56cc4fab2d54f2a816366b2dc8217f7b5ab64415925d0b7392d367b5f021ead4" callbackUrl:@"gimcbeacontracker://authcode"];
    [FYX enableLocationUpdates];
    
    [FYX startService:self];
    
    self.sightingManager = [[FYXSightingManager alloc] init];
    self.sightingManager.delegate = self;
    [self.sightingManager scan];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [self.sightingManager stopScan];
    
    [FYX stopService];
}

// FYXServiceDelegate - Ass4ss1n Zer0
- (void)serviceStarted {
    NSLog(@"FYX service started successfully");
    
    ViewController *controller = (ViewController*)self.window.rootViewController;
    Beacon *beacon = [[Beacon alloc] initWithName:@"Test transmitter" RSSI:[NSNumber numberWithDouble:-66] Date:[NSDate date] AndCoordinate:controller.mapView.userLocation.coordinate];
    
    [controller seenBeacon:beacon];
}

- (void)startServiceFailed:(NSError *)error {
    NSLog(@"FYX service failed to start: %@", error);
    // TODO: Let the user know and exit
}

// FYXSightingDelegate
- (void)didReceiveSighting:(FYXTransmitter *)transmitter time:(NSDate *)time RSSI:(NSNumber *)RSSI {
    NSLog(@"%@ Received sighting for beacon '%@' with strenght: %@", time, transmitter, RSSI);

    ViewController *controller = (ViewController*)self.window.rootViewController;
    Beacon *beacon = [[Beacon alloc] initWithName:transmitter.name RSSI:RSSI Date:time AndCoordinate:controller.mapView.userLocation.coordinate];
    
    [controller seenBeacon:beacon];
    
}

// From http://stackoverflow.com/questions/4955007/how-to-get-the-status-of-bluetooth-on-off-in-iphone-programatically/11780877
- (void)detectBluetooth
{
    if(!self.bluetoothManager)
    {
        // Put on main queue so we can call UIAlertView from delegate callbacks.
        self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:@{CBCentralManagerOptionShowPowerAlertKey:[NSNumber numberWithBool:NO]}];
    }
    [self centralManagerDidUpdateState:self.bluetoothManager]; // Show initial state
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSString *stateString = nil;
    switch(self.bluetoothManager.state)
    {
        case CBCentralManagerStateUnsupported: stateString = @"Your device does not support Bluetooth beacons, sorry."; break;
        case CBCentralManagerStateUnauthorized: stateString = @"The app is not authorized to use Bluetooth beacons."; break;
        case CBCentralManagerStatePoweredOff: stateString = @"Bluetooth is currently powered off, please enable it under Settings > Bluetooth."; break;
        default:
            break;
    }

    if(stateString) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bluetooth state"
                                                        message:stateString
                                                        delegate:nil
                                                        cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
    
}


@end
