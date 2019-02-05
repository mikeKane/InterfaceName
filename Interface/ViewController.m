//
//  ViewController.m
//  Interface
//
//  Created by Michael Kane on 2/5/19.
//  Copyright © 2019 Connectify. All rights reserved.
//

#import "ViewController.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *interfaceTextView;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    self.interfaceTextView.text = @"hi";
    [self getInterfaces];
}

- (void)getInterfaces {
    
    NSString *interfaceString = @"";
    NSLog(@"String %@", interfaceString);
    
    struct ifaddrs* interfaces = NULL;
    struct ifaddrs* temp_addr = NULL;
    
    // retrieve the current interfaces - returns 0 on success
    NSInteger success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL)
        {
            if (temp_addr->ifa_addr->sa_family == AF_INET) // internetwork only
            {
                NSString* name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString* address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                NSString *appendedName = [NSString stringWithFormat:@"Interface: %@. Address: %@\n", name, address];
                NSString *joinedString = [interfaceString stringByAppendingString:appendedName];
                interfaceString = joinedString;
            }
            
            temp_addr = temp_addr->ifa_next;
        }
        
        self.interfaceTextView.text = interfaceString;
    }
    
    // Free memory
    freeifaddrs(interfaces);
}
@end
