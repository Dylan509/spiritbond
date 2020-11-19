//
//  resetPassordViewController.swift
//  spiritbond
//
//  Created by lim jia le on 2020/9/25.
//

import UIKit
import Firebase
import FirebaseAuth

class resetPassordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var emailtextField: UITextField!
    
    @IBAction func submitaction(_ sender: AnyObject) {
        
        if self.emailtextField.text == "" {
            let alertController = UIAlertController(title: "Oops!", message: "請輸入你的郵件", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "好", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        
        } else {
            Auth.auth().sendPasswordReset(withEmail: self.emailtextField.text!, completion: { (error) in
                
                var title = ""
                var message = ""
                
                if error != nil {
                    title = "欸!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "好啦～"
                    message = "新的密碼已送到你的郵件"
                    self.emailtextField.text = ""
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "好", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
}
