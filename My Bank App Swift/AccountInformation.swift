//
//  AccountInformation.swift
//  My Bank App
//
//  Created by Jesse Gatt on 10/13/14.
//  Copyright (c) 2014 Callpod, Inc. All rights reserved.
//

import UIKit

private let _SingletonSharedInstance = AccountInformation()

class AccountInformation: NSObject {
    
    var username:String?
    var password:String?
    
    class var sharedInstance : AccountInformation {
        return _SingletonSharedInstance
    }
    
   
}
