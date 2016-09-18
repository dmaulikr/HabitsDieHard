//
//  LoginViewController.swift
//  HabitsDieHard
//
//  Created by Taro Minowa on 9/17/16.
//  Copyright © 2016 Higepon Taro Minowa. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FirebaseAuth
import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let loginButton = FBSDKLoginButton()
        loginButton.center = self.view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        // todo
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            // todo
            print(error.localizedDescription)
            return
        } else {
            if let currentToken = FBSDKAccessToken.current() {
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: currentToken.tokenString)
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    if let error = error {
                        // todo
                        print(error.localizedDescription)
                        return
                    } else {
                        let viewController = HabitsPageViewController()
                        UIApplication.shared.keyWindow?.rootViewController?.present(viewController, animated: true, completion: nil)
                    }
                }
            } else {
                // todo
                print("FB token is missing")
            }
        }
    }
}
