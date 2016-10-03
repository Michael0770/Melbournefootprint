//
//  loginCell.swift
//  melbourne1
//
//  Created by zihaowang on 3/10/2016.
//  Copyright © 2016 zihaowang. All rights reserved.
//

import UIKit

class loginCell: UITableViewCell {
    var signOutAction : (() -> Void)? = nil

    @IBOutlet weak var loginButton: UIButton!
    @IBAction func loginButtonAction(sender: AnyObject) {
    }
    @IBOutlet weak var signoutbutton: UIButton!
    @IBAction func signoutAction(sender: AnyObject) {
        if let signOutAction = self.signOutAction {
            signOutAction()
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
