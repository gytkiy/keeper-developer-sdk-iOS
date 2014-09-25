//
//  ViewController.m
//  My Bank App
//
//  Created by Arthur Walasek on 9/19/14.
//  Copyright (c) 2014 Callpod, Inc. All rights reserved.
//

#import "ViewController.h"
#import <KeeperExtensionSDK/KeeperExtensionSDK.h>
#import "AccountInformation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // A couple of different ways to show the keeper lock and activate the extension
//    [self.keeperLockBtn1 setHidden:![[KeeperSDK sharedExtension] isAppExtensionAvailable]];
//    [self.keeperLockBtn2 setHidden:![[KeeperSDK sharedExtension] isAppExtensionAvailable]];
    [self.keeperLockBtn1 setHidden:TRUE];
    [self.keeperLockBtn2 setHidden:TRUE];
    
    [self.keeperTabBtn setHidden:![[KeeperSDK sharedExtension] isAppExtensionAvailable]];
    
    self.txtUser.delegate = self;
    self.txtPassword.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *user = @"";
    if ([AccountInformation sharedInstance].username) {
        user = [AccountInformation sharedInstance].username;
    }
    self.txtUser.text = user;
    self.txtPassword.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [AccountInformation sharedInstance].username = self.txtUser.text;
    [AccountInformation sharedInstance].password = self.txtPassword.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
}

- (IBAction)lockAction:(id)sender {
    __weak typeof (self) miniMe = self;
    [[KeeperSDK sharedExtension] findLoginForURLString:@"http://www.my-bank-website.com" forViewController:self sender:sender completion:^(NSDictionary *loginDict, NSError *error) {
        if (!loginDict) {
            if (error.code != AppExtensionErrorCodeCancelledByUser) {
                NSLog(@"Error invoking Keeper App Extension for find login: %@", error);
            }
            return;
        }
        
        __strong typeof(self) strongMe = miniMe;
        strongMe.txtUser.text = loginDict[AppExtensionUsernameKey];
        strongMe.txtPassword.text = loginDict[AppExtensionPasswordKey];
    }];
}

@end
