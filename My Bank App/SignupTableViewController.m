//
//  SignupTableViewController.m
//  My Bank App
//
//  Created by Arthur Walasek on 9/23/14.
//  Copyright (c) 2014 Callpod, Inc. All rights reserved.
//

#import "SignupTableViewController.h"
#import "KeeperTableViewCell.h"
#import <KeeperExtensionSDK/KeeperExtensionSDK.h>
#import "AccountInformation.h"

@interface SignupTableViewController ()

@end

@implementation SignupTableViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.keeperTabBtn setHidden:![[KeeperSDK sharedExtension] isAppExtensionAvailable]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KeeperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"keeperCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[KeeperTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"keeperCell"];
    }
    if (indexPath.row == 0) {
        cell.txtText.secureTextEntry = FALSE;
        cell.txtText.placeholder = @"First Name";
        if (self.firstname) {
            cell.txtText.text = self.firstname;
        }
    }
    else if (indexPath.row == 1) {
        cell.txtText.secureTextEntry = FALSE;
        cell.txtText.placeholder = @"Last Name";
        if (self.lastname) {
            cell.txtText.text = self.lastname;
        }
    }
    else if (indexPath.row == 2) {
        cell.txtText.secureTextEntry = FALSE;
        cell.txtText.placeholder = @"Email";
        if (self.email) {
            cell.txtText.text = self.email;
        }
    }
    else if (indexPath.row == 3) {
        cell.txtText.secureTextEntry = TRUE;
        cell.txtText.placeholder = @"Password";
        if (self.password) {
            cell.txtText.text = self.password;
        }
    }
    
    cell.txtText.tag = indexPath.row;
    cell.delegate = self;
    cell.returnKeyType = UIReturnKeyDone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setUpCell];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 0) {
        self.firstname = textField.text;
    }
    else if (textField.tag == 1) {
        self.lastname = textField.text;
    }
    else if (textField.tag == 2) {
        self.email = textField.text;
    }
    else if (textField.tag == 3) {
        self.password = textField.text;
    }
}

#pragma mark - Actions

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Registration Successful" message:@"Your account has been created." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [AccountInformation sharedInstance].username = self.email;
        [AccountInformation sharedInstance].password = self.password;
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:dismissAction];
    [self presentViewController:alert animated:YES completion:nil];
    return;
}

- (IBAction)keeperAction:(id)sender {
    [self keeperLockAction];
}

- (void)keeperLockAction {
    NSDictionary *newLoginDetails = @{
                                      AppExtensionTitleKey: @"My Bank Registration",
                                      AppExtensionUsernameKey: self.email ? : @"",
                                      AppExtensionPasswordKey: self.password ? : @"",
                                      AppExtensionNotesKey: @"Saved with the My Bank app",
                                      AppExtensionSectionTitleKey: @"My Bank",
                                      AppExtensionFieldsKey: @{
                                              @"firstname" : self.firstname ? : @"",
                                              @"lastname" : self.lastname ? : @""
                                              // Add as many string fields as you please.
                                              }
                                      };
    
    // Password generation options are optional, but are very handy in case you have strict rules about password lengths
    NSDictionary *passwordGenerationOptions = @{
                                                AppExtensionGeneratedPasswordMinLengthKey: @(6),
                                                AppExtensionGeneratedPasswordMaxLengthKey: @(50)
                                                };
    
    __weak typeof (self) miniMe = self;
    
    [[KeeperSDK sharedExtension] storeLoginForURLString:@"http://www.my-bank-website.com" loginDetails:newLoginDetails passwordGenerationOptions:passwordGenerationOptions forViewController:self sender:self completion:^(NSDictionary *loginDict, NSError *error) {
        
        if (!loginDict) {
            if (error.code != AppExtensionErrorCodeCancelledByUser) {
                NSLog(@"Failed to use Keeper App Extension to save a new Login: %@", error);
            }
            return;
        }
        
        __strong typeof(self) strongMe = miniMe;
        
        strongMe.email = loginDict[AppExtensionUsernameKey] ? : @"";
        strongMe.password = loginDict[AppExtensionPasswordKey] ? : @"";
        strongMe.firstname = loginDict[AppExtensionReturnedFieldsKey][@"firstname"] ? : @"";
        strongMe.lastname = loginDict[AppExtensionReturnedFieldsKey][@"lastname"] ? : @"";
        // retrieve any additional fields that were passed in newLoginDetails dictionary
        
        [self.tableView reloadData];
    }];
}

@end
