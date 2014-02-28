//
//  SHRemoteConfigurationTests.m
//  SHRemoteConfigurationTests
//
//  Created by Stephan Harbauer on 28.02.14.
//  Copyright (c) 2014 Stephan Harbauer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SHRemoteConfiguration.h"
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface SHRemoteConfigurationTests : XCTestCase

@end

@implementation SHRemoteConfigurationTests {
    SHRemoteConfiguration *config;
}

- (void) setUp {
    [super setUp];
    config = [[SHRemoteConfiguration alloc] init];
}

- (void) tearDown {
    [super tearDown];
}

- (void) createTestConfig {
    NSDictionary *mockDict = mock([NSDictionary class]);
    [given([mockDict objectForKey:@"isAllowed"]) willReturnBool:YES];
    [given([mockDict objectForKey:@"isNotAllowed"]) willReturnBool:NO];
    [given([mockDict objectForKey:@"getString"]) willReturn:@"TestString"];

    [config setValue:mockDict forKey:@"permissionData"];
}

- (void) testSharedInstance {
    SHRemoteConfiguration *configurationUnderTest = [SHRemoteConfiguration sharedRemoteConfiguration];
    SHRemoteConfiguration *configurationUnderTest2 = [SHRemoteConfiguration sharedRemoteConfiguration];

    XCTAssertEqualObjects(configurationUnderTest, configurationUnderTest2, @"sharedRemoteConfiguration should always return the same object.");
}

- (void) testLoadConfigurationFromDefaults {
//    [config loadConfiguration:nil withDefaults:[[NSBundle bundleForClass:[self class]] pathForResource:@"testDefaults" ofType:@"json"]];
}

- (void) testLoadConfigurationFromRemote {
    // TODO improve test with mocks
    [config loadConfiguration:@"http://aquagen.info/testDefaults.json" withDefaults:nil];
    [NSThread sleepForTimeInterval:5.0];
    XCTAssertTrue([config isAllowedForPermissionName:@"isAllowed"]);
    XCTAssertFalse([config isAllowedForPermissionName:@"isNotAllowed"]);
    XCTAssertEqualObjects([config getStringForPermissionName:@"testString"], @"TestString");
}

- (void) testLoadConfigurationFromCache {

}

- (void) testIsAllowed {
    [self createTestConfig];

    XCTAssertTrue([config isAllowedForPermissionName:@"isAllowed"], @"isAllowed should return YES.");
}

- (void) testIsNotAllowed {
    [self createTestConfig];

    XCTAssertFalse([config isAllowedForPermissionName:@"isNotAllowed"], @"isAllowed should return NO.");

}

- (void) testIsAllowedWithWrongKeyName {
    [config setValue:[[NSDictionary alloc] init] forKey:@"permissionData"];

    XCTAssertFalse([config isAllowedForPermissionName:@"permissionName"], @"isAllowedForPermissionName should return NO if the key is unknown.");
}

- (void) testGetStringForPermission {
    [self createTestConfig];

    XCTAssertEqual([config getStringForPermissionName:@"getString"], @"TestString", @"getStringForPermissionName should return TestString.");
}

- (void) testGetStringForPermissionWithWrongPermissionName {
    [self createTestConfig];

    XCTAssertNil([config getStringForPermissionName:@"getStringNotHere"], @"getStringForPermissionName should return nil for wrong key.");
}

@end
