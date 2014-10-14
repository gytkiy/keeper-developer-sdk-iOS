//
//  KeeperTableViewCell.swift
//  My Bank App
//
//  Created by Jesse Gatt on 10/13/14.
//  Copyright (c) 2014 Callpod, Inc. All rights reserved.
//

import UIKit

class KeeperTableViewCell: UITableViewCell {

    @IBOutlet weak var txtText: UITextField!
    @IBOutlet weak var keeperLockBtn: UIButton!
    var delegate:AnyObject!
    var returnKeyType:UIReturnKeyType!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setUpCell() {
        txtText.returnKeyType = returnKeyType
        txtText.delegate = delegate as? UITextFieldDelegate
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
