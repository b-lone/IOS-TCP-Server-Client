//
//  iOS_TCP_Server_ClientTests.m
//  iOS-TCP-Server-ClientTests
//
//  Created by Đặng Văn Trường on 03/05/2017.
//  Copyright © 2017 Đặng Văn Trường. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "sendTCP.h"

@interface iOS_TCP_Server_ClientTests : XCTestCase

@end

@implementation iOS_TCP_Server_ClientTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    sendTCP *tcpClient = [[sendTCP alloc]init];
    [tcpClient sendsomethingAsClient:@"www.apple.com" port:(int)25 something:@"something"];
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
