//
//  KeeperTableViewCell.m
//  My Bank App
//
//  Created by Arthur Walasek on 9/23/14.
//  Copyright (c) 2014 Callpod, Inc. All rights reserved.
//

#import "KeeperTableViewCell.h"
#import <KeeperExtensionSDK/KeeperExtensionSDK.h>
#import "KeeperLockActionDelegate.h"

@implementation KeeperTableViewCell 

- (void)awakeFromNib {
    // Initialization code
#ifdef USE_KEEPER_TEXTFIELD_ICON
    [self.keeperLockBtn setHidden:![[KeeperSDK sharedExtension] isAppExtensionAvailable]];
#endif
}

- (void)setUpCell
{
    [self.txtText setReturnKeyType:self.returnKeyType];
    self.txtText.delegate = self.delegate;
    
#ifndef USE_KEEPER_TEXTFIELD_ICON
    [self.keeperLockBtn setHidden:TRUE];
#endif
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
