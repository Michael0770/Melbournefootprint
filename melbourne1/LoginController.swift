//
//  LoginController.swift
//  melbourne1
//
//  Created by zihaowang on 14/09/2016.
//  Copyright © 2016 zihaowang. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseDatabase
class LoginController: UIViewController, GIDSignInUIDelegate,GIDSignInDelegate {
    @IBOutlet weak var accountText: UITextField!

    @IBOutlet weak var passwordText: UITextField!
    
    @IBAction func loginButton(sender: AnyObject) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
       GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError?) {
        if let error = error {
            return
        }
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken,accessToken: authentication.accessToken)
        // ...
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            
        }
        if let user = FIRAuth.auth()?.currentUser {
            let name = user.displayName
            let email = user.email
            let photoUrl = user.photoURL
            let uid = user.uid;  // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with
            // your backend server, if you have one. Use
            // getTokenWithCompletion:completion: instead.
            print(name)
            print(email)
            print(photoUrl)
            print(uid)
          let ref = FIRDatabase.database().referenceFromURL("https://melbourne-footprint.firebaseio.com/")
         ref.child("users/\(uid)/email").setValue(email)

        } else {
            // No user is signed in.
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        try! FIRAuth.auth()!.signOut()
}
}