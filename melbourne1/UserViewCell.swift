//
//  UserViewCell.swift
//  melbourne1
//
//  Created by zihaowang on 19/09/2016.
//  Copyright © 2016 zihaowang. All rights reserved.
//

import UIKit

class UserViewCell: UITableViewCell {
    var signOutAction : (() -> Void)? = nil
    @IBOutlet weak var welcomeL: UILabel!
    @IBOutlet weak var signinAction: UIButton!
    @IBOutlet weak var singninButton: UIButton!
    @IBAction func singoutAction(sender: AnyObject) {
        if let signOutAction = self.signOutAction {
            signOutAction()
        }

    }
    @IBOutlet weak var signoutButton: UIButton!
    @IBOutlet weak var userNameL: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
