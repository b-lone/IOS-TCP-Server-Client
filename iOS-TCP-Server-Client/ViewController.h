//
//  ViewController.h
//  iOS-TCP-Server-Client
//
//  Created by Đặng Văn Trường on 03/05/2017.
//  Copyright © 2017 Đặng Văn Trường. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (nonatomic, strong) UITextView *textField;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic) BOOL launchSendflag;

-(void)autoSend;
-(void)sendUrl:(NSString*)urlString waitReturn:(BOOL)wait;

@end

