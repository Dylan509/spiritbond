//
//  SignUpViewController.swift
//  spiritbond
//
//  Created by lim jia le on 2020/9/25.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var emailtextField: UITextField!
    @IBOutlet weak var passwordtextField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var errorlabel: UILabel!
    
    let dbRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    func setUpElements() {
        errorlabel.alpha = 0
        
        Utilities.styleTextField(firstnameTextField)
        Utilities.styleTextField(lastnameTextField)
        Utilities.styleTextField(emailtextField)
        Utilities.styleTextField(passwordtextField)
        Utilities.styleFilledButton(signupButton)
    }
    

    func validateFields() -> String? {
        
        //check the all fields are filled in
        if firstnameTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastnameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailtextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordtextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "所有資料都需填上哦！"
        }
        //check if pass is secure
        let cleanedPassword = passwordtextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false {
            //pass isn't secure
            return "密碼至少需要8個字符哦！其中包括符號與數字"
        }
        return nil
        
    }

    @IBAction func signUptapped(_ sender: Any) {
        //validate fields
        let error = validateFields()
        
        if error != nil{
            //there is something wrong with fields
           showError(error!)
        }
        else{
            
            //create cleaned ver of data
            let firstName = firstnameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastnameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailtextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordtextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //check for error
                if  err != nil {
                    self.showError("Error creating User")
                }
                else{
                    let userId = (Auth.auth().currentUser?.email)!
                    let db = Firestore.firestore()
                    db.collection("users").document(userId).collection("detail").addDocument(data: ["balance":100000.0 ,"fiestname":firstName,"lastname":lastName,"uid":result!.user.uid]){(error) in
                        if error != nil{
                            self.showError("Error saving User data")
                        }
                        let userId:String = (Auth.auth().currentUser?.uid as String?)!
                        self.dbRef.child("Users/\(String(describing: userId))/balance").setValue(100000.0)
                        self.dbRef.child("Users/\(String(describing: userId))/stocks").setValue([:])
                        self.dbRef.child("Users/\(String(describing: userId))/name").setValue(lastName)
                        
                        let today: String = getDate()
                        let todayData: [String : Any] = ["balance": 100000.0, "stocks": [:] ]
                        self.dbRef.child("Users/\(String(describing: userId))/history/\(today)").setValue(todayData)
                        
                    }
                    //transition to home
                    self.transitionToHome()
                    
                }
            }
            
        }
        //create users
        
        
        
    }
    func showError(_ message:String)  {
        errorlabel.text = message
        errorlabel.alpha = 1
    }
    func transitionToHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.logInView) as? loginViewController
          
          view.window?.rootViewController = homeViewController
          view.window?.makeKeyAndVisible()
        
    }
}
