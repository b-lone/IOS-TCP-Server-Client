//
//  sendTCP.h
//  iOS-TCP-Server-Client
//
//  Created by guyqu on 7/20/17.
//  Copyright © 2017 Đặng Văn Trường. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface sendTCP : NSObject

-(NSString *)sendsomethingAsClient:(NSString*)addr port:(int)port something:(NSString *)dataString;
@end



