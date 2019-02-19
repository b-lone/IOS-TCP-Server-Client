//
//  ViewController.m
//  iOS-TCP-Server-Client
//
//  Created by Đặng Văn Trường on 03/05/2017.
//  Copyright © 2017 Đặng Văn Trường. All rights reserved.
//

#import "ViewController.h"
#import "sendTCP.h"

#define IPAddr (@"10.74.145.107")
#define Port (8899)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.launchSendflag=YES;
    // Do any additional setup after loading the view, typically from a nib.
    {
        self.textField = [[UITextView alloc]
                          initWithFrame:
                          CGRectMake(10.0f, 60.0f,
                                     300.0f, 100.0f)];
        
        [self.view addSubview:self.textField];
    }
    {
        self.button =    [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.button.frame = CGRectMake(110.0f, 600.0f, 150.0f, 30.0f);
        [self.button addTarget:self
                        action:@selector(buttonPressed)
              forControlEvents:UIControlEventTouchUpInside];
        [self.button setTitle:@"End all remote calls" forState:UIControlStateNormal];
        [self.view addSubview:self.button];
    }
    {
        self.textView = [[UITextView alloc]
                         initWithFrame:
                         CGRectMake(10.0f, 200.0f,
                                    300.0f, 100.0f)];
        [self.view addSubview:self.textView];
    }
    {
        self.webview = [[UIWebView alloc]initWithFrame:
                        CGRectMake(10.0f, 350.0f, 300.0f, 200.0f)];
        [self.view addSubview:self.webview];
    }
    
    //    self.label = [[UILabel alloc] initWithFrame:CGRectMake(150.0f, 100.0f, 40.0f, 40.0f)];
    //    [self.view addSubview:self.label];
    //
    //    [self setlabelIssue];
    
    
    [self getNetwork];
    if (self.launchSendflag) {
        [self autoSend];
    }
}

- (void)setlabelIssue{
    NSString* firstLine = @"aaaa";
    NSString* secondLine = @"bbbbb";
    
    NSDictionary *attributeDict_firstLine = @{
                                              NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName:[UIFont systemFontOfSize:13],
                                              };
    
    NSDictionary *attributeDict_secondLine = @{
                                               NSForegroundColorAttributeName : [UIColor colorWithRed:4/255.0 green:159/255.0 blue:217/255.0 alpha:1],
                                               NSFontAttributeName:[UIFont systemFontOfSize:17],
                                               };
    
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 1;
    
    NSDictionary *attributeDict = @{
                                    NSParagraphStyleAttributeName: paragraphStyle,
                                    };
    
    NSInteger lineNumber = 2;
    NSString* newLineString = lineNumber>1?@"\n":@"";
    NSString* twoLineCombine = [NSString stringWithFormat:@"%@%@%@",firstLine,newLineString,secondLine];
    NSMutableAttributedString* attributeButtonTitle = [[NSMutableAttributedString alloc] initWithString:twoLineCombine attributes:attributeDict];
    
    [attributeButtonTitle addAttributes:attributeDict_firstLine range:NSMakeRange(0, [firstLine length])];
    [attributeButtonTitle addAttributes:attributeDict_secondLine range:NSMakeRange([firstLine length]+[newLineString length], [twoLineCombine length]-([firstLine length] + [newLineString length]))];
    
    self.label.attributedText = attributeButtonTitle;
    self.label.numberOfLines = 2;
    
    self.label.layer.borderColor = [UIColor blueColor].CGColor;
    self.label.layer.borderWidth = 1;
    
    NSLog(@"frame:%@",self.label);
    
}

-(void)sendUrl:(NSString*)urlString waitReturn:(BOOL)wait{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"get Data from server");
        if (wait) {
            if (!error) {
                NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{ // Correct
                        [self.webview loadRequest:request];
                        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
                        NSLog(@"server data:\n%@\n",dict);
                    });
                }];
                [task resume];
            }
            NSLog(@"error with return http.");
        }
    }];
    [sessionDataTask resume];
}

-(void)getNetwork{
    [self sendUrl:@"https://8.8.8.8/" waitReturn:NO];
}

-(NSArray*)getArgument:(NSArray*)arguments{
    if (arguments.count<2) {
        return arguments;
    }
    else{
        if ([arguments[1] isEqualToString:@"launchFromJabber"]) {
            NSMutableArray *arrays=[NSMutableArray array];
            for (NSUInteger i=2; i<arguments.count; i++){
                NSString* singleArgument=arguments[i];
                NSString* strimstring = [singleArgument stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \n()"]];
                NSMutableArray *addArgu=[NSMutableArray arrayWithArray:[strimstring componentsSeparatedByString:@",\n"]];
                for (NSUInteger i=0;i<addArgu.count;i++) {
                    addArgu[i]=[addArgu[i] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \n\""]];
                }
                [arrays addObject:addArgu];
            }
            return arrays;
        }
        else if([arguments[1] isEqualToString:@"launchFromSelf"]){
            NSMutableArray *arrays=[NSMutableArray array];
            for (NSUInteger i=2; i<arguments.count; i++) {
                NSString* singleArgument=arguments[i];
                if ([singleArgument isEqualToString:@"("]) {
                    NSMutableArray *array_s=[NSMutableArray array];
                    NSUInteger end=i+1;
                    while (![arguments[end] isEqualToString:@")"]) {
                        NSString *b = [arguments[end] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" ,\""]];
                        [array_s addObject:b];
                        end+=1;
                    }
                    [arrays addObject:array_s];
                    i=end;
                }
                else{
                    [arrays addObject:singleArgument];
                }
            }
            return arrays;
        }
        else{
            return arguments;
        }
    }
}

-(void)autoSend{
    NSLog(@"autosend");
    sendTCP *tcpClient = [[sendTCP alloc]init];
    NSArray * arguments = [[NSProcessInfo processInfo] arguments];
    
    NSString * showInit=[NSString stringWithFormat:@"count:%lu\n",(unsigned long)arguments.count ];
    for (NSString *sss in arguments) {
        showInit=[showInit stringByAppendingFormat:@"\n%@",sss];
    }
    self.textView.text = showInit;
    
    NSArray * cmds = [self getArgument:arguments];
    
    if ([cmds isEqual:arguments]||!cmds) {
        return;
    }
    
    NSString* show2 = [NSString stringWithFormat:@"count:%lu\n",(unsigned long)cmds.count ];
    for (NSArray *sss in cmds) {
        for (NSString *single in sss) {
            show2=[show2 stringByAppendingFormat:@"\n%@",single];
        }
    }
    self.textField.text = show2;
    
    for (NSArray* single_cmd in cmds) {
        self.textField.text = [NSString stringWithFormat:@"send argument count:%lu",(unsigned long)single_cmd.count];
        if ([single_cmd[0] isEqualToString:@"TransDirectly"]&&single_cmd.count==4) {
            NSString * addr = single_cmd[1];
            int port = [single_cmd[2] intValue];
            NSString * data = single_cmd[3];
            NSString * returnLabel = [tcpClient sendsomethingAsClient:addr port:port something:data];
            self.textField.text = [NSString stringWithFormat:@"%@\n%@",data,returnLabel];
        }
        else if ([single_cmd[0] isEqualToString:@"JabberConfigChange"]&&single_cmd.count==2) {
            NSString * cmdSend = single_cmd[1];
            [self sendUrl:cmdSend waitReturn:YES];
            self.textField.text = [cmdSend stringByAppendingString:@"\nUrl cmd has sent.(by auto)"];
        }
    }
    
}

-(void)buttonPressed{
    sendTCP *tcpClient = [[sendTCP alloc]init];
    
//    NSString *addr= IPAddr;
//    int port =8899;
    
    NSArray *msgs=@[@"saruman@endcall@000",@"gollum@endcall@000"];
    for (NSString* msg in msgs) {
        self.textField.text = [msg stringByAppendingString:[tcpClient sendsomethingAsClient:IPAddr port:Port something:msg]];
    }
    NSString * cmdSend = @"http://changecfg.jabberqa.cisco.com/?changePart=undefined&changeKey=&changeValue=&configName=&Server=none";
    [self sendUrl:cmdSend waitReturn:YES];
    self.textView.text = [cmdSend stringByAppendingString:@"\nUrl cmd has sent.(by button)"];
    
}

-(void)urlLaunch{
    NSURL *url = [[NSURL alloc] initWithString:@"weixin://"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
