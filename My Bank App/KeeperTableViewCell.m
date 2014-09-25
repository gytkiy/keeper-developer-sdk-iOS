//
//  KeeperTableViewCell.m
//  My Bank App
//
//  Created by Arthur Walasek on 9/23/14.
//  Copyright (c) 2014 Callpod, Inc. All rights reserved.
//

#import "KeeperTableViewCell.h"
#import <KeeperExtensionSDK/KeeperExtensionSDK.h>

@implementation KeeperTableViewCell 

- (void)awakeFromNib {
    // Initialization code
    [self.keeperLockBtn setHidden:![[KeeperSDK sharedExtension] isAppExtensionAvailable]];
}

- (void)setUpCell
{
    [self.txtText setReturnKeyType:self.returnKeyType];
    self.txtText.delegate = self.delegate;
    
    // Take this away to show the Keeper lock within the Text Edit fields
    [self.keeperLockBtn setHidden:TRUE];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)keeperLockAction:(id)sender {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(keeperLockAction)]) {
            [self.delegate performSelector:@selector(keeperLockAction)];
        }
    }
}

@end
