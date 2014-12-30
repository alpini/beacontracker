//
//  BeaconTracker.m
//  beacontracker
//
//  Created by Lluis on 30/12/2014.
//
//

#import "BeaconTracker.h"

@implementation BeaconTracker

// From https://gist.github.com/tonycn/7566074
+ (NSString *) NSStringFromOSStatus:(OSStatus) errCode
{
    if (errCode == noErr)
        return @"noErr";
    char message[5] = {0};
    *(UInt32*) message = CFSwapInt32HostToBig(errCode);
    return [NSString stringWithCString:message encoding:NSASCIIStringEncoding];
}
@end
