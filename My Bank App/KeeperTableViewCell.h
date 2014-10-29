//
//  KeeperTableViewCell.h
//  My Bank App
//
//  Created by Arthur Walasek on 9/23/14.
//  Copyright (c) Keeper Security Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeeperTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *txtText;
@property (weak, nonatomic) IBOutlet UIButton *keeperLockBtn;
@property (strong, nonatomic) id delegate;
@property (assign) UIReturnKeyType returnKeyType;

- (IBAction)keeperLockAction:(id)sender;
- (void)setUpCell;

@end
