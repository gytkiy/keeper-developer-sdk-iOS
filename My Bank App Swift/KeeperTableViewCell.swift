//
//  KeeperTableViewCell.swift
//  My Bank App
//
//  Created by Jesse Gatt on 10/13/14.
//  Copyright (c) Keeper Security Inc. All rights reserved.
//

import UIKit
import KeeperExtensionSDK

class KeeperTableViewCell: UITableViewCell {

    @IBOutlet weak var txtText: UITextField!
    @IBOutlet weak var keeperLockBtn: UIButton!
    var delegate:AnyObject!
    var returnKeyType:UIReturnKeyType!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        #if USE_KEEPER_TEXTFIELD_ICON
            keeperLockBtn.hidden = !(KeeperSDK.sharedExtension().isAppExtensionAvailable())
        #endif
    }
    
    
    func setUpCell() {
        txtText.returnKeyType = returnKeyType
        txtText.delegate = delegate as? UITextFieldDelegate
        #if USE_KEEPER_TEXTFIELD_ICON
            keeperLockBtn.hidden = true
        #endif
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func keeperLockAction(sender: AnyObject) {
        
        if delegate.respondsToSelector(Selector("keeperLockAction:")) {
            delegate.keeperLockAction(sender)
        }

        
    }

}
