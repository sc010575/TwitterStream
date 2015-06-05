//
//  StreamTwittApplicationTests.m
//  StreamTwittApplicationTests
//
//  Created by Suman Chatterjee on 04/04/2015.
//  Copyright (c) 2015 Suman Chatterjee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AppDelegate.h"


@interface StreamTwittApplicationTests : XCTestCase
{

 AppDelegate *app_delegate;
}

@end

@implementation StreamTwittApplicationTests

- (void)setUp {
    [super setUp];
    app_delegate         = [[UIApplication sharedApplication] delegate];

    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testAppDelegate {
    XCTAssertNotNil(app_delegate, @"Cannot find the application delegate");
}


- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
