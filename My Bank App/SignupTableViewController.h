//
//  SignupTableViewController.h
//  My Bank App
//
//  Created by Arthur Walasek on 9/23/14.
//  Copyright (c) Keeper Security Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeeperLockActionDelegate.h"

@interface SignupTableViewController : UITableViewController <UITextFieldDelegate, KeeperLockActionDelegate>

@property (strong, nonatomic) NSString *firstname;
@property (strong, nonatomic) NSString *lastname;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (weak, nonatomic) IBOutlet UIButton *keeperTabBtn;


- (IBAction)cancelAction:(id)sender;
- (IBAction)registerAction:(id)sender;
- (IBAction)keeperAction:(id)sender;

@end
