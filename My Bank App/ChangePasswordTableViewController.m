//
//  ChangePasswordTableViewController.m
//  My Bank App
//
//  Created by Arthur Walasek on 9/23/14.
//  Copyright (c) 2014 Callpod, Inc. All rights reserved.
//

#import "ChangePasswordTableViewController.h"
#import "KeeperTableViewCell.h"
#import <KeeperExtensionSDK/KeeperExtensionSDK.h>

@interface ChangePasswordTableViewController ()

@end

@implementation ChangePasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

#ifdef USE_KEEPER_TAB_ICON
    [self.keeperTabBtn setHidden:![[KeeperSDK sharedExtension] isAppExtensionAvailable]];
#else
    [self.keeperTabBtn setHidden:TRUE];
#endif
    
    [self.tableView setRowHeight:44.0f];
    [self.tableView.tableHeaderView setFrame:CGRectMake(self.tableView.tableHeaderView.bounds.origin.x, self.tableView.tableHeaderView.bounds.origin.y, self.tableView.tableHeaderView.bounds.size.width, 135)];
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KeeperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"keeperCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[KeeperTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"keeperCell"];
    }
    if (indexPath.row == 0) {
        cell.txtText.secureTextEntry = TRUE;
        cell.txtText.placeholder = @"Old Password";
        if (self.oldpassword) {
            cell.txtText.text = self.oldpassword;
        }
    }
    else if (indexPath.row == 1) {
        cell.txtText.secureTextEntry = TRUE;
        cell.txtText.placeholder = @"New Password";
        if (self.password1) {
            cell.txtText.text = self.password1;
        }
    }
    else if (indexPath.row == 2) {
        cell.txtText.secureTextEntry = TRUE;
        cell.txtText.placeholder = @"Confirm Password";
        if (self.password2) {
            cell.txtText.text = self.password2;
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
        self.oldpassword = textField.text;
    }
    else if (textField.tag == 1) {
        self.password1 = textField.text;
    }
    else if (textField.tag == 2) {
        self.password2 = textField.text;
    }
}

#pragma mark - Actions

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Password Changed" message:@"Your password has been changed" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alert addAction:dismissAction];
    [self presentViewController:alert animated:YES completion:nil];
    return;
}

- (IBAction)keeperAction:(id)sender {
    [self keeperLockAction];
}

- (void)keeperLockAction {
    NSString *changedPassword = self.password1 ? : @"";
    
    // Validate that the new and confirmation passwords match.
    if (changedPassword.length > 0 && ![changedPassword isEqualToString:self.password2]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Change Password Error" message:@"The new and the confirmation passwords must match" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            self.password1 = @"";
            self.password2 = @"";
            [self.tableView reloadData];
        }];
        
        [alert addAction:dismissAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSDictionary *loginDetails = @{
                                   AppExtensionTitleKey: @"My Bank Registration",
                                   AppExtensionPasswordKey: changedPassword,
                                   AppExtensionOldPasswordKey: self.oldpassword ? : @"",
                                   AppExtensionNotesKey: @"Saved with the My Bank app",
                                   };
    
    // Password generation options are optional, but are very handy in case you have strict rules about password lengths
    NSDictionary *passwordGenerationOptions = @{
                                                AppExtensionGeneratedPasswordMinLengthKey: @(6),
                                                AppExtensionGeneratedPasswordMaxLengthKey: @(50)
                                                };
    
    __weak typeof (self) miniMe = self;
    
    [[KeeperSDK sharedExtension] changePasswordForLoginForURLString:@"http://www.my-bank-website.com" loginDetails:loginDetails passwordGenerationOptions:passwordGenerationOptions forViewController:self sender:self completion:^(NSDictionary *loginDict, NSError *error) {
        if (!loginDict) {
            if (error.code != AppExtensionErrorCodeCancelledByUser) {
                NSLog(@"Failed to use Keeper App Extension to change password: %@", error);
            }
            return;
        }
        
        __strong typeof(self) strongMe = miniMe;
        strongMe.oldpassword = loginDict[AppExtensionOldPasswordKey];
        strongMe.password1 = loginDict[AppExtensionPasswordKey];
        strongMe.password2 = loginDict[AppExtensionPasswordKey];
        
        [self.tableView reloadData];
    }];
}

@end
