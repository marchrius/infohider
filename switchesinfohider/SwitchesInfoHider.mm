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
    
    if (![traduzioni load])
    {
        return specifiers;
    }
    
    [self setTitle:[traduzioni localizedStringForKey:@"Switches" value:@"Switches" table:nil]]; // Localize title controller
    

    
    NSBundle* settingsBundle = [NSBundle bundleWithPath:@"/Applications/Preferences.app"];
    
    if (![settingsBundle load])
    {
        return specifiers;
    }
    
    for(PSSpecifier *spec in specifiers) {
        NSString *name = [spec name];
        
        if(name)
        {
            [spec setName:[settingsBundle localizedStringForKey:name value:name table:nil]];
        }
        
        NSString *label = [spec propertyForKey:@"label"];
        if(label)
        {
            [spec setProperty:[settingsBundle localizedStringForKey:label value:label table:nil] forKey:@"label"];
        }
    }
    return specifiers;
}
    
@end

// vim:ft=objc
