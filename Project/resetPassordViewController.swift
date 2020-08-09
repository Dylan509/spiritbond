//
//  resetPassordViewController.swift
//  SpiritBond
//
//  Created by Fung Ying Hei on 29/7/2020.
//  Copyright © 2020 茂木匠. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class resetPassordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var emailTextField: UITextField!

    // Reset Password Action
    @IBAction func submitAction(_ sender: AnyObject) {
        
        if self.emailTextField.text == "" {
            let alertController = UIAlertController(title: "Oops!", message: "請輸入你的郵件", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "好", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        
        } else {
            Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!, completion: { (error) in
                
                var title = ""
                var message = ""
                
                if error != nil {
                    title = "欸!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "好啦～"
                    message = "新的密碼已送到你的郵件"
                    self.emailTextField.text = ""
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "好", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    
}
