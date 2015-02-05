//
//  EngageConfigManager.m
//  EngageSDK
//
//  Created by Jeremy Dyer on 5/28/14.
//  Copyright (c) 2014 Silverpop. All rights reserved.
//

#import "EngageConfigManager.h"

@interface EngageConfigManager ()

@property (strong, nonatomic) NSDictionary *configs;

@end

@implementation EngageConfigManager

- (id) init {
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EngageConfigDefaults" ofType:@"plist" inDirectory:ENGAGE_CONFIG_BUNDLE];
        if (path == nil) {
            path  = [[NSBundle mainBundle] pathForResource:@"EngageConfigDefaults" ofType:@"plist"];
            if (path == nil) {
                NSBundle *unitTestBundle = [NSBundle bundleForClass:[self class]];
                path = [unitTestBundle pathForResource:@"EngageConfigDefaults" ofType:@"plist"];
            }
        }
        
        if (path) {
            self.configs = [[NSDictionary alloc] initWithContentsOfFile:path];
            NSLog(@"EngageSDK - %lu SDK defaults loaded from EngageConfigDefaults.plist file at path %@", (unsigned long)[self.configs count], path);
        } else {
            [NSException raise:@"Invalid EngageSDK configuration" format:@"Unable to locate required EngageConfigDefaults.plist default configuration file!"];
        }
        
        //Looks for a SDK user defined plist file as well and merges those into the
        //existing configurations with the SDK defined configs taking precedence
        NSString *sdkPath = [[NSBundle mainBundle] pathForResource:@"EngageConfig" ofType:@"plist"];
        if (sdkPath) {
            NSDictionary *userConfigs = [[NSDictionary alloc] initWithContentsOfFile:sdkPath];
            if (userConfigs) {
                NSMutableDictionary *engageConfigs;
                if (self.configs) {
                    engageConfigs = [self.configs mutableCopy];
                } else {
                    engageConfigs = [[NSMutableDictionary alloc] init];
                }
                
                [engageConfigs addEntriesFromDictionary:userConfigs];
                self.configs = engageConfigs;
                
                NSLog(@"EngageSDK - EngageConfig.plist configurations loaded and merged with precedence over EngageConfigDefaults.plist values");
                NSLog(@"%@", self.configs);
            }
        } else {
            NSLog(@"EngageSDK - No user defined EngageConfig.plist file found in main bundle EngageSDK defaults will be used.");
        }
    }
    return self;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t p = 0;
    
    __strong static EngageConfigManager *_configManager = nil;
    
    dispatch_once(&p, ^{
        _configManager = [[self alloc] init];
    });
    
    return _configManager;
}

- (BOOL)locationServicesEnabled {
    return (BOOL) [[[self.configs objectForKey:@"LocationServices"] valueForKey:@"enabled"] intValue];
}

- (NSString *)fieldNameForUBF:(NSString *)ubfFieldConstantName {
    return (NSString *)[[self.configs objectForKey:@"UBFFieldNames"] objectForKey:ubfFieldConstantName];
}

- (NSNumber *)configForNetworkValue:(NSString *)networkFieldConstantName {
    return (NSNumber *)[[self.configs objectForKey:@"Networking"] objectForKey:networkFieldConstantName];
}

- (long)longConfigForSessionValue:(NSString *)sessionFieldConstantName {
    return (long)[[self.configs objectForKey:@"Session"] objectForKey:sessionFieldConstantName];
}

- (NSString *)fieldNameForParam:(NSString *)paramFieldConstantName {
    return (NSString *)[[self.configs objectForKey:@"ParamFieldNames"] objectForKey:paramFieldConstantName];
}

- (NSString *)configForGeneralFieldName:(NSString *)generalFieldConstantName {
    return (NSString *)[[self.configs objectForKey:@"General"] objectForKey:generalFieldConstantName];
}

- (NSNumber *)numberConfigForGeneralFieldName:(NSString *)generalFieldConstantName {
    return (NSNumber *)[[self.configs objectForKey:@"General"] objectForKey:generalFieldConstantName];
}

- (NSString *)configForLocationFieldName:(NSString *)locationFieldConstantName {
    return (NSString *)[[self.configs objectForKey:@"LocationServices"] objectForKey:locationFieldConstantName];
}

- (NSNumber *)numberConfigForLocalStoreFieldName:(NSString *)localStoreFieldConstantName {
    return (NSNumber *)[[self.configs objectForKey:@"LocalEventStore"] objectForKey:localStoreFieldConstantName];
}

- (NSString *)configForAugmentationServiceFieldName:(NSString *)augmentationServiceFieldConstantName {
    return (NSString *)[[self.configs objectForKey:@"Augmentation"] objectForKey:augmentationServiceFieldConstantName];
}

- (NSArray *)augmentationPluginClassNames {
    return (NSArray *) [[self.configs objectForKey:@"Augmentation"] objectForKey:@"augmentationPluginClasses"];
}


@end
