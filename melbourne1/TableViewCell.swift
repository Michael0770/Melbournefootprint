//
//  TableViewCell.swift
//  melbourne1
//
//  Created by zihaowang on 18/08/2016.
//  Copyright © 2016 zihaowang. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var isFavorate = NSUserDefaults.standardUserDefaults().boolForKey("isFavorate")
    
    @IBOutlet weak var faButton: UIButton!
    @IBAction func isFav(sender: AnyObject) {
        if isFavorate == true {
            let image = UIImage(named: "Heart_icon.png")
            self.faButton.setImage(image, forState: UIControlState.Normal)
            print(NSUserDefaults.standardUserDefaults().boolForKey("isFavorate"))
        } else {
            let image = UIImage(named: "heart_icon_selected.png")
            self.faButton.setImage(image, forState: UIControlState.Normal)
        }
        
        isFavorate = !isFavorate
    NSUserDefaults.standardUserDefaults().setBool(isFavorate, forKey: "isFavorate")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    @IBOutlet weak var tableImageView: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var addressL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let image = UIImage(named: "Heart_icon.png")
        self.faButton.setImage(image, forState: UIControlState.Normal)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
