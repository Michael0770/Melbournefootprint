//
//  favouriteTableCell.swift
//  melbourne1
//
//  Created by zihaowang on 18/09/2016.
//  Copyright © 2016 zihaowang. All rights reserved.
//

import UIKit

class favouriteTableCell: UITableViewCell {
    @IBOutlet weak var tableImageView: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var addressL: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
            }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
