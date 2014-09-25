//
//  ViewController.h
//  My Bank App
//
//  Created by Arthur Walasek on 9/19/14.
//  Copyright (c) 2014 Callpod, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtUser;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *keeperLockBtn1;
@property (weak, nonatomic) IBOutlet UIButton *keeperLockBtn2;
@property (weak, nonatomic) IBOutlet UIButton *keeperTabBtn;

- (IBAction)lockAction:(id)sender;

@end

