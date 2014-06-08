//
//  InfoHiderSettings.h
//  InfoHiderSettings
//
//  Created by Matteo Gaggiano on 08.01.2014.
//  Copyright (c) 2014 Matteo Gaggiano. All rights reserved.
//

#include <Preferences/PSSpecifier.h>
#include <Preferences/PSListController.h>
#include <AppleAccount/AADeviceInfo.h>
#include "../version.h"

@interface InfoHiderSettingsListController : PSListController
    
@property (nonatomic, retain) NSMutableDictionary* settings;
@property (nonatomic) BOOL enabledAll;

- (id)specifiers;
//- (void)visitWebsite:(id)arg;
//- (void)visitTwitter:(id)arg;
//- (NSString*)version;
//- (void)setPreferenceValue:(id)value specifier:(id)specifier;
    
@end