//
//  loginViewController.swift
//  spiritbond
//
//  Created by lim jia le on 2020/9/24.
//

import UIKit
import Firebase
import FirebaseAuth

struct Constants {
    
    struct Storyboard {
        
        static let homeViewController = "HomeVC"
        static let FundRaise = "fundVC"
        static let logInView = "logIn"
    }
}

class loginViewController: UIViewController {
    
    var currentUser: CurrentUser? = nil
    let db = Firestore.firestore()
    @IBOutlet weak var emailtextField: UITextField!
    @IBOutlet weak var passwordtextField: UITextField!
    @IBOutlet weak var loginbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func logintapped(_ sender: AnyObject) {
        
        let email = emailtextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordtextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if self.emailtextField.text == "" || self.passwordtextField.text == "" {
            
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
                        
                    self.currentUser = CurrentUser()
                    self.currentUser?.getUserData{ success in
                        guard success else { return }
                        self.performSegue(withIdentifier: "logInToHome" , sender: self)
                       
                    }
                 //   let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                   //     self.view.window?.rootViewController = homeViewController
                     //   self.view.window?.makeKeyAndVisible()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "LogInToSignUp" {
            let tabVC = segue.destination as! UITabBarController
            let exploreNavVC = tabVC.viewControllers![3] as! UINavigationController
            let explore = exploreNavVC.topViewController as! stockTableView
            explore.currentUser = self.currentUser
            
            let portfolionavVC = tabVC.viewControllers![0] as! UINavigationController
            let portfolio = portfolionavVC.topViewController as! HomeUserViewController
            portfolio.currentUser = self.currentUser
        }
    }
}
