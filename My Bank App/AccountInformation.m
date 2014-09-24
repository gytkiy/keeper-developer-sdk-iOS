//
//  AccountInformation.m
//  My Bank App
//
//  Created by Arthur Walasek on 9/23/14.
//  Copyright (c) 2014 Callpod, Inc. All rights reserved.
//

#import "AccountInformation.h"

@implementation AccountInformation

+ (AccountInformation *)sharedInstance
{
    static dispatch_once_t onceToken;
    static AccountInformation *__sharedInstance;
    
    dispatch_once(&onceToken, ^{
        __sharedInstance = [AccountInformation new];
    });
    
    return __sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.username = @"";
        self.password = @"";
    }
    return self;
}

@end
