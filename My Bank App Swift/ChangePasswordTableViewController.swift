//
//  ChangePasswordTableViewController.swift
//  My Bank App
//
//  Created by Jesse Gatt on 10/13/14.
//  Copyright (c) 2014 Callpod, Inc. All rights reserved.
//

import UIKit
import KeeperExtensionSDK

class ChangePasswordTableViewController: UITableViewController, UITextFieldDelegate, KeeperLockActionDelegate {

    @IBOutlet weak var keeperTabBtn: UIButton!
    var oldpassword:NSString?
    var password1:NSString?
    var password2:NSString?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        #if USE_KEEPER_TAB_ICON
            keeperTabBtn.hidden = !(KeeperSDK.sharedExtension().isAppExtensionAvailable())
        #else
            keeperTabBtn.hidden = true
        #endif
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 3
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("keeperCell", forIndexPath: indexPath) as KeeperTableViewCell

        // Configure the cell...
        
        switch indexPath.row {
        case 0:
            cell.txtText.secureTextEntry = true
            cell.txtText.placeholder = "Old Password"
            if let oldpassword = oldpassword {
                cell.txtText.text = oldpassword
            }
        case 1:
            cell.txtText.secureTextEntry = true
            cell.txtText.placeholder = "New Password"
            if let password1 = password1 {
                cell.txtText.text = password1
            }
        case 2:
            cell.txtText.secureTextEntry = true
            cell.txtText.placeholder = "Confirm Password"
            if let password2 = password2 {
                cell.txtText.text = password2
            }
        default:
            cell.txtText.text = ""
        }
        
        
        // Configure the cell...
        
        cell.txtText.tag = indexPath.row
        cell.delegate = self
        cell.returnKeyType = UIReturnKeyType.Done
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.setUpCell()


        return cell
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        switch textField.tag {
        case 0:
            oldpassword = textField.text
        case 1:
            password1 = textField.text
        case 2:
            password2 = textField.text
        default:
            println("Default Case")
        }
    }
    
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func changeAction(sender: AnyObject) {
        
        
        
        let alert = UIAlertController(title: "Password Changed", message: "Your password has been changed", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.presentViewController(alert, animated: true, completion: nil)
        return;
    }

    @IBAction func keeperLockAction(sender: AnyObject) {
        
        let changePassword = password1 ?? ""
        
        if (changePassword.length > 0) && !(changePassword == password2) {
            let alert = UIAlertController(title: "Change Password Error", message: "The new and the confirmation passwords must match", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            
            password1 = ""
            password2 = ""
            self.presentViewController(alert, animated: true, completion: nil)
            return;
        }
        
        let loginDetails = [AppExtensionTitleKey: "My Bank Registration",
            AppExtensionPasswordKey: changePassword,
            AppExtensionOldPasswordKey: oldpassword ?? "",
            AppExtensionNotesKey: "Saved with the My Bank app"]
        
        let passwordGenerationOptions = [AppExtensionGeneratedPasswordMinLengthKey: 6, AppExtensionGeneratedPasswordMaxLengthKey: 50]
        
        KeeperSDK.sharedExtension().changePasswordForLoginForURLString("http://www.my-bank-website.com", loginDetails: loginDetails, passwordGenerationOptions: passwordGenerationOptions, forViewController: self, sender: sender) { (loginDict:[NSObject : AnyObject]!, error:NSError!) -> Void in
            if error.code != AppExtensionErrorCodeCancelledByUser {
                println("Failed to use Keeper App Extension to change password: \(error)")
                return
            }
            
            self.oldpassword = loginDict[AppExtensionOldPasswordKey] as? NSString
            self.password1 = loginDict[AppExtensionOldPasswordKey] as? NSString
            self.password2 = loginDict[AppExtensionOldPasswordKey] as? NSString
            
            self.tableView.reloadData()
        }

    }
}
