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
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID){
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
// facebook authentication
    @IBAction func facebookBtnTapped(_ sender: RoundButton) {
        
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
                if let user = user {
                    self.completeSignIn(id: (user.uid))
                }
            }
        })
    }

   
    @IBAction func signInTapped(_ sender: AnyObject) {
        
        if let email = emailField.text, let pwd = passwordField.text {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("JORGE: email user authenticated with firebase")
                    if let user = user {
                        self.completeSignIn(id: (user.uid))
                    }

                }
                else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("JORGE: unable to auth with firebase")
                        }
                        else{
                            print("JORGE: Succesfully authenticated with firebase")
                            if let user = user {
                                self.completeSignIn(id: (user.uid))
                            }
                            
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(id: String){
        let keyChainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("JORGE: Data saved to keychain \(keyChainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
}

