//
//  SignupTableViewController.swift
//  My Bank App
//
//  Created by Jesse Gatt on 10/13/14.
//  Copyright (c) 2014 Callpod, Inc. All rights reserved.
//

import UIKit
import KeeperExtensionSDK

class SignupTableViewController: UITableViewController, UITextFieldDelegate, KeeperLockActionDelegate {

    @IBOutlet weak var keeperTabBtn: UIButton!
    
    var firstName:String?
    var lastName:String?
    var email:String?
    var password:String?
    
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
        return 4
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("keeperCell", forIndexPath: indexPath) as KeeperTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.txtText.secureTextEntry = false
            cell.txtText.placeholder = "First Name"
            if let firstName = firstName {
                cell.txtText.text = firstName
            }
        case 1:
            cell.txtText.secureTextEntry = false
            cell.txtText.placeholder = "Last Name"
            if let lastName = lastName {
                cell.txtText.text = lastName
            }
        case 2:
            cell.txtText.secureTextEntry = false
            cell.txtText.placeholder = "Email"
            if let email = email {
                cell.txtText.text = email
            }
        case 3:
            cell.txtText.secureTextEntry = true
            cell.txtText.placeholder = "Password"
            if let password = password {
                cell.txtText.text = password
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }

    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {

        switch textField.tag {
        case 0:
            firstName = textField.text
        case 1:
            lastName = textField.text
        case 2:
            email = textField.text
        case 3:
            password = textField.text
        default:
            println("Default Case")
        }
    }

    
    
    // MARK: - Keeper Lock Actions
    
    @IBAction func registerAction(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Registration Successful", message: "Your account has been created.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))

        AccountInformation.sharedInstance.username = self.email
        AccountInformation.sharedInstance.password = self.password
        self.dismissViewControllerAnimated(true, completion: nil)
        self.presentViewController(alert, animated: true, completion: nil)


        return;
    }

    @IBAction func keeperLockAction(sender: AnyObject) {
        
        var newLoginDetails : [NSString:AnyObject] = Dictionary()
        newLoginDetails[AppExtensionTitleKey] = "My Bank Registration"
        newLoginDetails[AppExtensionUsernameKey] = email ?? ""
        newLoginDetails[AppExtensionPasswordKey] = password ?? ""
        newLoginDetails[AppExtensionNotesKey] = "Saved with the My Bank app"
        newLoginDetails[AppExtensionSectionTitleKey] = "My Bank"
        newLoginDetails[AppExtensionFieldsKey] = ["firstname" : firstName ?? "", "lastname": lastName ?? ""]
        
        
        
        let passwordGenerationOptions = [AppExtensionGeneratedPasswordMinLengthKey: 6, AppExtensionGeneratedPasswordMaxLengthKey: 50]
        
        KeeperSDK.sharedExtension().storeLoginForURLString("http://www.my-bank-website.com", loginDetails: newLoginDetails, passwordGenerationOptions: passwordGenerationOptions, forViewController: self, sender: sender) { (loginDict:[NSObject : AnyObject]!, error:NSError!) -> Void in
            
            if (error != nil) {
                let newError = error as NSError!
                if (newError.code != AppExtensionErrorCodeCancelledByUser) {
                    println("Error invoking Keeper App Extension for find login: \(error)")
                }
                return;
                
            }
            
            if (loginDict != nil) {
                
                
                self.email = (loginDict[AppExtensionUsernameKey] ?? "") as NSString
                self.password = (loginDict[AppExtensionPasswordKey] ?? "") as NSString
                let nameDict = loginDict[AppExtensionReturnedFieldsKey] as Dictionary<String, AnyObject>
                self.firstName = (nameDict["firstname"] ?? "") as NSString
                self.lastName = (nameDict["lastname"] ?? "") as NSString

                self.tableView.reloadData()
            }
            
            
        }
        
        

        
        
    }
}
