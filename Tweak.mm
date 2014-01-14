//
//  Tweak.xm
//  InfoHiderSettings
//
//  Created by Matteo Gaggiano on 08.01.2014.
//  Copyright (c) 2014 Matteo Gaggiano. All rights reserved.
//

#import <Preferences/Preferences.h>
#import <AppleAccount/AADeviceInfo.h>
#import <UIKit/UIKit2.h>
#import <Foundation/Foundation.h>

BOOL mustShowLog = YES;
BOOL canCopyIt = YES;
BOOL isTheTweakEnabled = NO;
BOOL useCustomMessage = NO;
BOOL useRefresh = NO;
NSString *message =  nil;
NSDictionary *settings = nil;
UIRefreshControl* refreshControl = nil;

#define DLOG(fmt, ...) if (mustShowLog) NSLog(@"InfoHider: " fmt, ##__VA_ARGS__)

@interface AboutController
-(NSArray*)specifiers;
-(void)reload;
-(void)reloadSpecifiers;
-(void)viewDidLoad;
-(UINavigationItem*)navigationItem;
-(UITableView*)table;
-(void)insertSpecifier:(PSSpecifier*)specifier atIndex:(int)index animated:(BOOL)animated;
-(void)removeSpecifierAtIndex:(int)index;
-(void)replaceContiguousSpecifiers:(NSArray*)specifiers withSpecifiers:(NSArray*)specifiers2 animated:(BOOL)animated;
-(void)replaceContiguousSpecifiers:(NSArray*)specifiers withSpecifiers:(NSArray*)specifiers2;
@end

%hook AboutController

-(void)viewDidLoad
{%orig;
    
    settings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.marchrius.infohidersettings.plist"];
    
    if (!settings) {
        DLOG(@"Error occured while loading preferences. Abort.");
        return;
    }
    
    isTheTweakEnabled = [[settings objectForKey:@"enableTweak"] boolValue];
    
    if (!isTheTweakEnabled) {
        return;
    }
    
    DLOG(@"AboutController in Preferences detected.");
    
    useCustomMessage = [[settings objectForKey:@"useCustomMessage"] boolValue];
    
    if (useCustomMessage) {
        message = [settings objectForKey:@"message"];
    }
    
    NSArray* onlyWifi = @[@"iPad1,1", @"iPad2,1", @"iPad2,4", @"iPad2,5", @"iPad3,1", @"iPad3,4", @"iPad4,1", @"iPad4,4", @"iPod1,1", @"iPod2,1", @"iPod3,1", @"iPod4,1", @"iPod5,1"]; //Devices to skip
    
    NSMutableArray* keys = [NSMutableArray arrayWithArray:@[@"Network", @"Songs", @"Videos", @"Photos", @"Applications", @"Capacity", @"Available", @"Version", @"Carrier", @"Model", @"Serial Number", @"Phone Number", @"Wi-Fi Address", @"Bluetooth", @"IMEI", @"ICCID", @"Firmware Modem"]]; // All keys
    
    NSArray* keysToSkip = @[@"Network", @"Carrier", @"Phone Number", @"IMEI", @"ICCID", @"Firmware Modem"]; //Keys to skip
    
    id productType, osVersion;
    
    id device = [[%c(AADeviceInfo) alloc] init];
    
    productType = [device productType];
    
    osVersion = [device osVersion];
    
    DLOG(@"Running on %@ (%@)", osVersion, productType);

    mustShowLog = [[settings objectForKey:@"debugMode"] boolValue];
    
    canCopyIt = [[settings objectForKey:@"canCopyIt"] boolValue];
    
    useRefresh = [[settings objectForKey:@"canAddRefreshControl"] boolValue];

    if (useRefresh && ([osVersion hasPrefix:@"6."] || [osVersion hasPrefix:@"7."]))
    {
        DLOG(@"Adding refreshControl. (Only native)");
        refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(reloadSpecifiers)
                 forControlEvents:UIControlEventValueChanged];
        [[self table] addSubview:refreshControl];
    }
    
    int toSkip = 0;
    
    if ([productType hasPrefix:@"iPhone"])
    {
        DLOG(@"iPhone don't have the Phone Number in About View. Removing it.");
        toSkip = 1;
        [keys removeObjectsInArray:@[@"Phone Number"]];
    } else if ([onlyWifi containsObject:productType]) {
        DLOG(@"This is a WiFi only device.");
        toSkip += keysToSkip.count;
        [keys removeObjectsInArray:keysToSkip];
    }
    
    NSArray *specifiers = [NSArray arrayWithArray:[[self specifiers] subarrayWithRange:NSMakeRange(3, keys.count)]];
    
    int i = 0;
    
    for ( i = 0; i < specifiers.count; i++)
    {
        PSSpecifier *currentSpecifier = [specifiers objectAtIndex:i];
        
        NSString* aKey = [keys objectAtIndex:i];
        
        NSString* currentName = [currentSpecifier name];
        
        NSNumber* flagString = [settings objectForKey:aKey];
        
        BOOL flag = [flagString boolValue];
        
        DLOG(@"%@ -> %@ : %@ : %@", currentName, aKey, flagString, (flag) ? @"YES" : @"NO");

        DLOG(@"properties %@", [currentSpecifier properties]);
        
        if (flag) {
            PSSpecifier* newSpecifier = [[%c(PSSpecifier) preferenceSpecifierNamed:currentName
                                                                          target:self
                                                                             set:NULL
                                                                             get:@selector(valueForSpecifier:)
                                                                          detail:Nil
                                                                            cell:PSTitleValueCell
                                                                            edit:Nil] autorelease];
            
            [newSpecifier setProperty:@"yes" forKey:@"isChangedDueToTweak"];
            [self replaceContiguousSpecifiers:@[currentSpecifier] withSpecifiers:@[newSpecifier] animated:YES];
        }
        
        if (canCopyIt && !flag) {
            [[currentSpecifier properties] setObject:[NSNumber numberWithInt:1] forKey:@"isCopyable"];
        } else {
            [[currentSpecifier properties] setObject:[NSNumber numberWithInt:0] forKey:@"isCopyable"];
        }
    }
    
    [self reload];
}

- (NSString *) valueForSpecifier: (PSSpecifier *) specifier {
    
    %orig;
    
    if ([specifier propertyForKey:@"isChangedDueToTweak"] != nil)
    {
        
        if (message != nil && [message length] == 0) {
            message = @"\U0000e333";
        }
        
        return (useCustomMessage) ? message : @"\U0000e333";
    }
    
    return %orig;
}

%end

%hook UITableView
- (void)reloadData
{
    %orig;
    if (refreshControl != nil && isTheTweakEnabled) {
        if ([refreshControl isRefreshing])
        {
            [refreshControl endRefreshing];
        }
    }
}
%end

%hook AboutController
- (void)reloadSpecifiers
{
    if (refreshControl != nil && isTheTweakEnabled) {
        [self reload];
        [[self table] reloadData];
    }
    
    if (isTheTweakEnabled) return;

    %orig;
}

%end

