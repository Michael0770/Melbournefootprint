//
//  searchAllCellController.swift
//  melbourne1
//
//  Created by zihaowang on 15/09/2016.
//  Copyright © 2016 zihaowang. All rights reserved.
//

import UIKit

class searchAllCellController: UITableViewCell {
    var isFavorate2 = NSUserDefaults.standardUserDefaults().boolForKey("isFavorate2")
    
    @IBOutlet weak var faButton: UIButton!
   
    @IBAction func isFav(sender: AnyObject) {
        if isFavorate2 == true {
            let image = UIImage(named: "Heart_icon.png")
            self.faButton.setImage(image, forState: UIControlState.Normal)
            print(NSUserDefaults.standardUserDefaults().boolForKey("isFavorate2"))
        } else {
            let image = UIImage(named: "heart_icon_selected.png")
            self.faButton.setImage(image, forState: UIControlState.Normal)
        }
        
        isFavorate2 = !isFavorate2
        NSUserDefaults.standardUserDefaults().setBool(isFavorate2, forKey: "isFavorate2")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    @IBOutlet weak var tableImageView: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var addressL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        var image = UIImage(named:"Heart_icon")
        self.faButton.setImage(image, forState: UIControlState.Normal)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    


}
