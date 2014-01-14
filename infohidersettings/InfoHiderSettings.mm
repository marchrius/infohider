//
//  InfoHiderSettings.mm
//  InfoHiderSettings
//
//  Created by Matteo Gaggiano on 08.01.2014.
//  Copyright (c) 2014 Matteo Gaggiano. All rights reserved.
//

#import "InfoHiderSettings.h"

@implementation InfoHiderSettingsListController
    
- (id)specifiers {
    
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"InfoHiderSettings" target:self] retain];
        [self localizedSpecifiersWithSpecifiers:_specifiers];
	}
	return _specifiers;
}
    
- (id)localizedSpecifiersWithSpecifiers:(NSArray *)specifiers {
    
    for(PSSpecifier *spec in specifiers) {
        NSString *name = [spec name];
        
        if(name)
        {
            [spec setName:[[self bundle] localizedStringForKey:name value:name table:nil]];
        }
        
        NSString *footerText = [spec propertyForKey:@"footerText"];
        if(footerText)
        {
            [spec setProperty:[[self bundle] localizedStringForKey:footerText value:footerText table:nil] forKey:@"footerText"];
        }
        
        NSString *placeholder = [spec propertyForKey:@"placeholder"];
        if(placeholder)
        {
            [spec setProperty:[[self bundle] localizedStringForKey:placeholder value:placeholder table:nil] forKey:@"placeholder"];
        }
        
        NSString *label = [spec propertyForKey:@"label"];
        if(label)
        {
            [spec setProperty:[[self bundle] localizedStringForKey:label value:label table:nil] forKey:@"label"];
        }
        
        id titleDict = [spec titleDictionary];
        if(titleDict) {
            NSMutableDictionary *newTitles = [[NSMutableDictionary alloc] init];
            for(NSString *key in titleDict) {
                NSString *value = [titleDict objectForKey:key];
                [newTitles setObject:[[self bundle] localizedStringForKey:value value:value table:nil] forKey: key];
            }
            [spec setTitleDictionary:newTitles];
        }
    }
    return specifiers;
}
    
- (void)visitWebsite:(id)arg {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://marchrius.altervista.org/blog/"]];
}
    
- (void)visitTwitter:(id)arg {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/Marchrius"]];
}

- (void)paypalDonate:(id)arg
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=XS9D8AAK5XERA&lc=GB&item_name=Matteo%20Gaggiano&item_number=A%20thanks%20for%20tweaks&currency_code=EUR&bn=PP%2dDonationsBF%3abtn_donate_SM%2egif%3aNonHosted"]];
}

- (NSString*)valueForSpecifier:(PSSpecifier*)specifier
{
    return [NSString stringWithFormat:@"%@ (%@)", VERSION, BUILD];
}

@end
