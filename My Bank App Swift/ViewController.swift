//
//  ViewController.swift
//  My Bank App Swift
//
//  Created by Jesse Gatt on 10/13/14.
//  Copyright (c) 2014 Callpod, Inc. All rights reserved.
//

import UIKit
import KeeperExtensionSDK

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var keeperLockBtn1: UIButton!
    @IBOutlet weak var keeperLockBtn2: UIButton!
    @IBOutlet weak var keeperTabBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        if KeeperSDK.sharedExtension().isAppExtensionAvailable(){
//            keeperLockBtn1.hidden = KeeperSDK.sharedExtension().isAppExtensionAvailable()
//            keeperLockBtn2.hidden = KeeperSDK.sharedExtension().isAppExtensionAvailable()
//        }
        

        
        
        txtUser.delegate = self
        txtPassword.delegate = self
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        if (AccountInformation.sharedInstance.username != nil) {
            txtUser.text = AccountInformation.sharedInstance.username
        }
        
        txtPassword.text = ""
        
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        AccountInformation.sharedInstance.username = txtUser.text
        AccountInformation.sharedInstance.password = txtPassword.text
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }

    @IBAction func lockAction(sender: AnyObject) {
        
        KeeperSDK.sharedExtension().findLoginForURLString("http://www.my-bank-website.com", forViewController: self, sender: sender) { (loginDict:[NSObject : AnyObject]!, error:NSError!) -> Void in
            
            if (error != nil) {
                let newError = error as NSError!
                if (newError.code != AppExtensionErrorCodeCancelledByUser) {
                    println("Error invoking Keeper App Extension for find login: \(error)")
                }
                return;
                
            }
            
            if (loginDict != nil) {
                
                self.txtUser.text = loginDict[AppExtensionUsernameKey] as NSString
                self.txtPassword.text = loginDict[AppExtensionPasswordKey] as NSString
                
            }
            
        }
    }

}

