//
//  SignInVC.swift
//  SocialDeck
//
//  Created by Jorge Osuna Benitez on 3/29/17.
//  Copyright © 2017 Jorge Osuna Benitez. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
// facebook authentication
    @IBAction func facebookBtnTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                
                print("unable to authenticate - \(error)")
                
            }
            else if result?.isCancelled == true{
                print("cancelled fb auth")
            }
            else {
                print("successfully authenticated")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    //Firebase authentication, useful with google, facebook, email
    func firebaseAuth(_ credential: FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("unable to authenticate")
            }
            else{
                print("succesfully authenticated with firebase")
            }
        })
    }

}

