//
//  AccountInformation.h
//  My Bank App
//
//  Created by Arthur Walasek on 9/23/14.
//  Copyright (c) Keeper Security Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountInformation : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

+ (AccountInformation *)sharedInstance;

@end
