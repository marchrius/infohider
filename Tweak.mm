//
//  Tweak.xm
//  InfoHiderSettings
//
//  Created by Matteo Gaggiano on 08.01.2014.
//  Copyright (c) 2014 Matteo Gaggiano. All rights reserved.
//

#import "Tweak.h"
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
    
    
    
    NSArray* keysPreferences = @[@"Network",       @"Line", @"Songs",
                              @"Videos",        @"Photos", @"Applications",
                              @"Capacity",      @"Available", @"Version", @"Carrier",
                              @"Model",         @"Serial Number", @"Phone Number",
                              @"Wi-Fi Address", @"Bluetooth", @"IMEI",
                              @"ICCID",         @"MEID", @"Firmware Modem"]; // All keys
    
   NSArray* keys = @[@"NETWORK", @"LINE", @"SONGS", @"VIDEOS", @"PHOTOS",
                             @"APPLICATIONS", @"User Data Capacity",
                             @"User Data Available", @"ProductVersion",@"CARRIER_VERSION",
                             @"ProductModel", @"SerialNumber", @"CellularDataAddress",
                             @"MACAddress", @"BTMACAddress", @"ModemIMEI", @"ICCID",
                             @"MEID", @"ModemVersion"];
    
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

    PSSpecifier* currentSpecifier = nil;
    for (id key in keys)
    {
        NSString* name = [[self bundle] localizedStringForKey:key value:key table:nil];
        
        currentSpecifier = nil;
        
        if (![key isEqualToString:@"SONGS"] &&
            ![key isEqualToString:@"VIDEOS"] &&
            ![key isEqualToString:@"PHOTOS"] &&
            ![key isEqualToString:@"CARRIER_VERSION"])
        {
            currentSpecifier = [self specifierForID:name];
        } else {
            currentSpecifier = [self specifierForID:key];
        }
        
        if (currentSpecifier == nil )
        {
            DLOG(@"Specifier %@ (%@) non trovato!", key, name);
            continue;
        }
        
        NSString* currentName = [currentSpecifier name];
        
        NSString* aKey = [keysPreferences objectAtIndex:[keys indexOfObject:key]];
        
        NSNumber* flagString = [settings objectForKey:aKey];
        
        BOOL flag = [flagString boolValue];
        
        DLOG(@"%@ -> %@ : %@ : %@", currentName, aKey, flagString, (flag) ? @"YES" : @"NO");
        
        if (flag) {
            PSSpecifier* newSpecifier = [%c(PSSpecifier) preferenceSpecifierNamed:currentName
                                                                          target:self
                                                                             set:NULL
                                                                             get:@selector(valueForSpecifier:)
                                                                          detail:Nil
                                                                            cell:PSTitleValueCell
                                                                            edit:Nil];
            
            [newSpecifier setProperty:@"yes" forKey:@"isChangedDueToTweak"];
            
            [self replaceContiguousSpecifiers:@[currentSpecifier] withSpecifiers:@[newSpecifier] animated:NO];
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

