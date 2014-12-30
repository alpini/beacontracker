//
//  ViewController.h
//  beacontracker
//
//  Created by Lluis on 21/12/2014.
//  Copyright (c) 2014 Lluis Mora. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AudioToolbox/AudioToolbox.h>
#import "Beacon.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    SystemSoundID pingSoundLow;
    SystemSoundID pingSoundMedium;
    SystemSoundID pingSoundHigh;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property CFURLRef pingSoundCFURLLow;
@property CFURLRef pingSoundCFURLMedium;
@property CFURLRef pingSoundCFURLHigh;

- (Beacon *) getBeacon:(NSString *)name;
- (void) seenBeacon:(Beacon *)beacon;
- (void) playPing:(int)signal;

@end

