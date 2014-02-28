//
//  SHRemoteConfiguration.m
//  SHRemoteConfiguration
//
//  Created by Stephan Harbauer on 28.02.14.
//  Copyright (c) 2014 Stephan Harbauer. All rights reserved.
//

#import "SHRemoteConfiguration.h"

@implementation SHRemoteConfiguration {
    NSDictionary *permissionData;
}

const NSString *cachedDataPath = @"Documents/SHRemoteConfigurationCache.json";

+ (SHRemoteConfiguration *)sharedRemoteConfiguration {
    static SHRemoteConfiguration *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (void) loadConfiguration:(NSURL *)configurationUrl withDefaults:(NSString *)localFilePath {
    // check if old data are in cache
    permissionData = [self readCachedData];

    if (!permissionData && localFilePath) {
        // load data
        permissionData = [[NSDictionary alloc] initWithContentsOfFile:localFilePath];
    }

    if (configurationUrl) {
        // TODO load new data

        // TODO save data in cache
    }
}

- (BOOL) isAllowedForPermissionName:(NSString *)permisionName {
    return [[permissionData objectForKey:permisionName] boolValue];
}

- (NSString *) getStringForPermissionName:(NSString *)permissionName {
    id value = [permissionData objectForKey:permissionName];
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString *) value;
    }
    return nil;
}


#pragma mark - private methods

- (void) writeCachedData:(NSDictionary *)cacheData {
    if ([[NSFileManager defaultManager] fileExistsAtPath:cachedDataPath]) {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:cachedDataPath error:&error];
        if (error) {
            NSLog(@"Error on deleting old SHRemoteConfiguration cache");
        }
    }

    [[NSFileManager defaultManager] createFileAtPath:cachedDataPath contents:cacheData attributes:nil];
}

/**
* Returns the cached data as NSDictionary or nil if there is no cached data.
*/
- (NSDictionary *) readCachedData {
    return [[NSDictionary alloc] initWithContentsOfFile:cachedDataPath];
}

@end
