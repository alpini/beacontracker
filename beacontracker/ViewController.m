//
//  ViewController.m
//  beacontracker
//
//  Created by Lluis on 21/12/2014.
//  Copyright (c) 2014 Lluis Mora. All rights reserved.
//

#import "ViewController.h"
#import "BeaconTracker.h"
#import "Beacon.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController ()

@end

@implementation ViewController

NSMutableArray *beacons;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    beacons = [[NSMutableArray alloc] init];
    OSStatus ret;

    NSURL *pingSoundURLLow = [[NSBundle mainBundle] URLForResource:@"ping_low" withExtension:@"aiff"];
    self.pingSoundCFURLLow = (CFURLRef) CFBridgingRetain(pingSoundURLLow);
    ret = AudioServicesCreateSystemSoundID(self.pingSoundCFURLLow, &self->pingSoundLow);
    
    NSURL *pingSoundURLMedium = [[NSBundle mainBundle] URLForResource:@"ping_medium" withExtension:@"aiff"];
    self.pingSoundCFURLMedium = (CFURLRef) CFBridgingRetain(pingSoundURLMedium);
    ret = AudioServicesCreateSystemSoundID(self.pingSoundCFURLMedium, &self->pingSoundMedium);

    NSURL *pingSoundURLHigh = [[NSBundle mainBundle] URLForResource:@"ping_high" withExtension:@"aiff"];
    self.pingSoundCFURLHigh = (CFURLRef) CFBridgingRetain(pingSoundURLHigh);
    ret = AudioServicesCreateSystemSoundID(self.pingSoundCFURLHigh, &self->pingSoundHigh);
    
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:TRUE];

    MKCoordinateRegion mkcr = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate,100.0,100.0);
    [self.mapView setRegion:mkcr animated: FALSE];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    AudioServicesDisposeSystemSoundID(self->pingSoundLow);
    CFRelease (self.pingSoundCFURLLow);

    AudioServicesDisposeSystemSoundID(self->pingSoundMedium);
    CFRelease (self.pingSoundCFURLMedium);

    AudioServicesDisposeSystemSoundID(self->pingSoundHigh);
    CFRelease (self.pingSoundCFURLHigh);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [beacons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    Beacon *beacon = [beacons objectAtIndex:indexPath.row];

    cell.textLabel.text = beacon.name;

    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"hh:mm:ss"];

    cell.detailTextLabel.text = [NSString stringWithFormat:@"Last seen at %@h with strength %@", [formatter stringFromDate:beacon.seen], beacon.rssi];
    return cell;
}

- (Beacon *) getBeacon:(NSString *)name
{
    Beacon *tmp, *ret = NULL;

    for(int i=0; i < beacons.count; i++) {
        tmp = beacons[i];

        if([tmp.name isEqualToString:name]) {
            ret = tmp;
            break;
        }
    }
    
    return ret;
}

- (void) seenBeacon:(Beacon *)beacon
{
    Beacon *tmp;

    tmp = [self getBeacon:beacon.name];
    [self playPing:[beacon.rssi intValue]];

    // Add sample overlay

    if(tmp) {
        [self.mapView removeOverlay:tmp];
        [self.mapView removeAnnotation:tmp];
        [beacons removeObject:tmp];
    }

    [beacons addObject:beacon];
    [self.mapView addOverlay:beacon level:MKOverlayLevelAboveLabels];
    [self.mapView addAnnotation:beacon];
    
    [self.tableView reloadData];
}

- (void) playPing:(int)signal {
    
    SystemSoundID *pingSound = &self->pingSoundHigh;

    if(signal < -90) {
        pingSound = &self->pingSoundLow;
    } else if (signal < -80) {
        pingSound = &self->pingSoundMedium;
    }

    AudioServicesPlaySystemSound(*pingSound);
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self.mapView setCenterCoordinate:[userLocation coordinate]];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (   [annotation isKindOfClass:[Beacon class]]) {
        Beacon *beacon = (Beacon *)annotation;
        static NSString *identifier = @"Beacon";
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            // annotationView.image = [UIImage imageNamed:@"arrest.png"];//here we use a nice image instead of the default pins
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
    
    if ([overlay isKindOfClass:[Beacon class]]){
        
        Beacon *beacon = (Beacon *)overlay;
        
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:beacon.coordinate radius:[beacon.distance doubleValue]];
        MKCircleRenderer *circleR = [[MKCircleRenderer alloc] initWithCircle:circle];

        circleR.fillColor = [UIColor redColor];
//        circleR.strokeColor = [UIColor whiteColor];
        circleR.alpha = 0.5f;
        
        return circleR;
    }
    return nil;
}

- (IBAction)mapTypeChanged:(id)sender {
    switch (self.mapTypeSegmentedControl.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
    /*
    Beacon *beacon = [[Beacon alloc] initWithName:@"Test transmitter" RSSI:[NSNumber numberWithDouble:-66] Date:[NSDate date] AndCoordinate:self.mapView.userLocation.coordinate];
    
    [self seenBeacon:beacon];
     */

}
@end
