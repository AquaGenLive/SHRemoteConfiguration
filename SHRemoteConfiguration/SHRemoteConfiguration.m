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

- (void) loadConfiguration:(NSString *)configurationUrl withDefaults:(NSString *)localFilePath {
    // check if old data are in cache.
    permissionData = [self readCachedData];

    // load data from preset.
    if (!permissionData && localFilePath) {
        permissionData = [[NSDictionary alloc] initWithContentsOfFile:localFilePath];
    }

    // load data from remote configuration.
    if (configurationUrl) {
        [self performSelectorInBackground:@selector(downloadConfigurationForm:) withObject:configurationUrl];
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

- (void) downloadConfigurationForm:(NSString *)downloadPath {
    NSURL *url = [NSURL URLWithString:downloadPath];
    NSData *remoteConfigurationNSData = [NSData dataWithContentsOfURL:url];

    if (remoteConfigurationNSData) {
        NSError *jsonError = nil;
        id json = [NSJSONSerialization JSONObjectWithData:remoteConfigurationNSData options:0 error:&jsonError];

        if (jsonError) {
            NSLog(@"Error with remote JSON");
        } else {
            permissionData = (NSDictionary *) json;
            [self writeCachedData:permissionData];
        }
    } else {
        NSLog(@"Unable to download remote configuration.");
    }
}

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
