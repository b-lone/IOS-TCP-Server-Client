//
//  AppDelegate.m
//  iOS-TCP-Server-Client
//
//  Created by Đặng Văn Trường on 03/05/2017.
//  Copyright © 2017 Đặng Văn Trường. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()
{
    ViewController *viewController;
    BOOL sendKey;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]
                   initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    viewController = [[ViewController alloc] init];
    
    self.window.rootViewController = viewController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return true;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

-(void)checkSomething{
    NSString *cmdSend =@"http://changecfg.jabberqa.cisco.com/?changePart=undefined&changeKey=&changeValue=&configName=&Server=none";
    [viewController sendUrl:cmdSend waitReturn:YES];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if (!viewController.launchSendflag) {
        [viewController autoSend];
        sendKey=true;
    }
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    if (!viewController.launchSendflag) {
        if (!sendKey) {
            [viewController autoSend];
        }
    }
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
