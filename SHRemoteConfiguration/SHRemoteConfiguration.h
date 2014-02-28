//
//  SHRemoteConfiguration.h
//  SHRemoteConfiguration
//
//  Created by Stephan Harbauer on 28.02.14.
//  Copyright (c) 2014 Stephan Harbauer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHRemoteConfiguration : NSObject

+ (SHRemoteConfiguration *)sharedRemoteConfiguration;

- (void)loadConfiguration:(NSString *)configurationUrl withDefaults:(NSString *)localFilePath;

- (BOOL)isAllowedForPermissionName:(NSString *)permisionName;

- (NSString *)getStringForPermissionName:(NSString *)permissionName;
@end
