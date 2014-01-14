#import <Preferences/Preferences.h>

@interface SwitchesInfoHiderListController: PSListController
{
    
}
@end

@implementation SwitchesInfoHiderListController
    
- (id)specifiers {
    
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"SwitchesInfoHider" target:self] retain];
        [self localizedSpecifiersWithSpecifiers:_specifiers];
	}
	return _specifiers;
}
    
- (id)localizedSpecifiersWithSpecifiers:(NSArray *)specifiers {
    
    
    NSBundle *traduzioni = [NSBundle bundleWithPath:@"/Library/PreferenceBundles/InfoHiderSettings.bundle"];
    
    [self setTitle:[traduzioni localizedStringForKey:@"Switches" value:@"Switches" table:nil]]; // Localize title controller
    
    if (![traduzioni load])
    {
        return specifiers;
    }
    
    for(PSSpecifier *spec in specifiers) {
        NSString *name = [spec name];
        
        if(name)
        {
            [spec setName:[traduzioni localizedStringForKey:name value:name table:nil]];
        }
        
        NSString *footerText = [spec propertyForKey:@"footerText"];
        if(footerText)
        {
            [spec setProperty:[traduzioni localizedStringForKey:footerText value:footerText table:nil] forKey:@"footerText"];
        }
        
        NSString *placeholder = [spec propertyForKey:@"placeholder"];
        if(placeholder)
        {
            [spec setProperty:[traduzioni localizedStringForKey:placeholder value:placeholder table:nil] forKey:@"placeholder"];
        }
        
        NSString *label = [spec propertyForKey:@"label"];
        if(label)
        {
            [spec setProperty:[traduzioni localizedStringForKey:label value:label table:nil] forKey:@"label"];
        }
        
        id titleDict = [spec titleDictionary];
        if(titleDict) {
            NSMutableDictionary *newTitles = [[NSMutableDictionary alloc] init];
            for(NSString *key in titleDict) {
                NSString *value = [titleDict objectForKey:key];
                [newTitles setObject:[traduzioni localizedStringForKey:value value:value table:nil] forKey: key];
            }
            [spec setTitleDictionary:newTitles];
        }
    }
    return specifiers;
}
    
@end

// vim:ft=objc
