//
//  ChangePasswordTableViewController.h
//  My Bank App
//
//  Created by Arthur Walasek on 9/23/14.
//  Copyright (c) 2014 Callpod, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeeperLockActionDelegate.h"

@interface ChangePasswordTableViewController : UITableViewController <UITextFieldDelegate, KeeperLockActionDelegate>

@property (strong, nonatomic) NSString *oldpassword;
@property (strong, nonatomic) NSString *password1;
@property (strong, nonatomic) NSString *password2;
@property (weak, nonatomic) IBOutlet UIButton *keeperTabBtn;

- (IBAction)cancelAction:(id)sender;
- (IBAction)changeAction:(id)sender;
- (IBAction)keeperAction:(id)sender;

@end
