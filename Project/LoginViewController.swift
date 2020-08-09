//
//  loginViewController.swift
//  SpiritBond
//
//  Created by Fung Ying Hei on 29/7/2020.
//  Copyright © 2020 茂木匠. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class loginViewController: UIViewController {
        
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func loginTapped(_ sender: AnyObject) {
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "欸！", message: "郵件或密碼有誤喔", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "好", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        
        } else {
        
        // Signing in the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    
                if error != nil {
                    // Couldn't sign in
                    let alertController = UIAlertController(title: "欸！", message: "郵件或密碼有誤喔", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "好", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                else {
                        
                    let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                        
                        self.view.window?.rootViewController = homeViewController
                        self.view.window?.makeKeyAndVisible()
                }
            }
        }
    }

}
