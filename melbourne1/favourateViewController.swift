//
//  favourateViewController.swift
//  melbourne1
//
//  Created by zihaowang on 14/09/2016.
//  Copyright © 2016 zihaowang. All rights reserved.
//

import UIKit
import Firebase
class favourateViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var favourateTableView: UITableView!
    @IBAction func logInViewButton(sender: AnyObject) {
        
    }
    override func viewWillAppear(animated: Bool) {
        self.favourateTableView.delegate = self
        self.favourateTableView.dataSource = self
        if let user = FIRAuth.auth()?.currentUser {
            // User is signed in.
            self.loginButton.hidden = true
        } else {
            // No user is signed in.
            self.favourateTableView.hidden = true
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.favourateTableView.delegate = self
        self.favourateTableView.dataSource = self
        if let user = FIRAuth.auth()?.currentUser {
            // User is signed in.
            self.loginButton.hidden = true
        } else {
            // No user is signed in.
            self.favourateTableView.hidden = true
        }
        
            }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return  0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        return UITableViewCell()
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }

}
