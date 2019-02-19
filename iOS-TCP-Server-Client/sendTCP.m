//
//  sendTCP.m
//  iOS-TCP-Server-Client
//
//  Created by guyqu on 7/20/17.
//  Copyright © 2017 Đặng Văn Trường. All rights reserved.
//

#import "sendTCP.h"

#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include "arpa/inet.h"
#include <errno.h>
#include <stdio.h>
#include <unistd.h>
#include <strings.h>
#include <sys/types.h>

@implementation sendTCP


-(NSString *)sendsomethingAsClient:(NSString*)addr port:(int)port something:(NSString *)dataString{
    int socketFileDescriptor = socket(AF_INET, SOCK_STREAM, 0);
    NSString *returnString = @"";
    if (-1 == socketFileDescriptor) {
        NSLog(@"Failed to create socket.");
    }
    
    struct sockaddr_in socketParameters;
    socketParameters.sin_family = AF_INET;
    socketParameters.sin_addr.s_addr = inet_addr([addr UTF8String]);
    socketParameters.sin_port = htons(port);
    bzero(&(socketParameters.sin_zero), 8);
    
    int ret = connect(socketFileDescriptor, (struct sockaddr *) &socketParameters, sizeof(socketParameters));
    if ( ret<0) {
        close(socketFileDescriptor);
        NSString * errorInfo = [NSString stringWithFormat:@" >> Failed to connect to %@:%d.\nBecause connect error: %s(errno: %d)\n", addr, port,strerror(errno),errno];
        NSLog(@"%@",errorInfo);
        returnString=errorInfo;
    }
    else{
        returnString=[NSString stringWithFormat:@" >> Successfully connected to %@:%d", addr, port];
        NSLog(@"%@",returnString);
        
    }
    NSData *message = [dataString dataUsingEncoding:NSISOLatin1StringEncoding];
    
    ssize_t datalen = write(socketFileDescriptor, [message bytes], [message length]);
    if((unsigned long)datalen == [message length])
    {
        NSLog(@"Send str:%@",message);
    }
    return returnString;
}

@end
