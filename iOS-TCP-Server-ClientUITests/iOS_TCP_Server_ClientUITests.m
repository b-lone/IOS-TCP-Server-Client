//
//  iOS_TCP_Server_ClientUITests.m
//  iOS-TCP-Server-ClientUITests
//
//  Created by Đặng Văn Trường on 03/05/2017.
//  Copyright © 2017 Đặng Văn Trường. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "sendTCP.h"

@interface iOS_TCP_Server_ClientUITests : XCTestCase

@end

@implementation iOS_TCP_Server_ClientUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    XCUIApplication *app=[[XCUIApplication alloc] init];
    
    NSArray* robots=@[@"gollum"];
    
    NSMutableArray* cmds = [NSMutableArray array];
    [cmds addObject:@"launchFromSelf"];
    for (NSString* robot in robots) {
        NSString*msg=[NSString stringWithFormat:@"%@@endcall@000",robot];
        NSArray* aCmd = @[@"TransDirectly",@"10.74.145.125",@(8899),msg];
        [cmds addObject:aCmd];
    }
    
    [app setLaunchArguments:cmds];
    [app launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    XCUIApplication * safari  = [[XCUIApplication alloc] performSelector:@selector(initPrivateWithPath:bundleID:)
                                                                   withObject:nil
                                                                   withObject:@"com.apple.mobilesafari"];
#pragma clang diagnostic pop
    safari.launchArguments=@[@"-u",@"https://www.goole.com"];
    [safari launch];
    sendTCP *tcpClient = [[sendTCP alloc]init];
    NSArray* robots=@[@"gollum",@"saruman"];
    NSMutableArray* cmds = [NSMutableArray array];
    NSMutableArray* addrs = [NSMutableArray array];
    NSMutableArray* ports = [NSMutableArray array];
    for (NSString* robot in robots) {
        [cmds addObject:[NSString stringWithFormat:@"%@@endcall@000",robot]];
        [addrs addObject:@"10.74.145.125"];
        [ports addObject:@(8899)];
    }
    
    
    for (NSUInteger i=0;i<addrs.count;i++) {
        [tcpClient sendsomethingAsClient:addrs[i] port:[ports[i] intValue] something:cmds[i]];
    }

}

@end
