//
//  RaiseFundInvestViewController.swift
//  spiritbond
//
//  Created by lim jia le on 2020/9/24.
//

import UIKit
import Firebase

class RaiseFundInvestViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var raisingamountTextField: UITextField! {
        didSet {
            raisingamountTextField.delegate = self
            raisingamountTextField.tag = 7
        }
    }
    
    var raiseFundInfo : RaiseFundInfo?
    var date: String?
    var editMode: Bool = false
    var tempOfRasing: Int?
    var nameOfTitle: String?
    var creator: String?
    var rasingAmount: Int?
    var stock: String?
    var rateReturn: Double?
    var txtDate: String?
    var deadlineDate: String?
    var investorAmount: Int?
    let db = Firestore.firestore()
    var tempOfUser: Int?
    var tempOfUserTmep: Int?

    
    var abc: Int?
    
    @IBAction func okbutton(_ sender: UIButton) {
        if raisingamountTextField.text != "" {
            
            let temp = Int(raisingamountTextField.text!) ?? 0
            let rasingAmount = temp + tempOfRasing!
            
            raiseFundInfo = RaiseFundInfo( creator: creator, title: nameOfTitle, rateReturn: rateReturn, stock: stock, txtDate: txtDate, date: date!, raisingAmount: rasingAmount, temp: temp , deadlineDate: deadlineDate )
            
            showAlertOk(title: "提醒", message: "投資完成！！！")
            
        }
        else {
            showAlertMessage(title: "Oops!有少資料喔！", message: "還沒填入投入資金")
        }
    }
    
    func showAlertOk(title: String, message: String) {
        let inputErrorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert) //產生AlertController
        let okAction = UIAlertAction(title: "確認", style: .default, handler: { action  in
            self.performSegue(withIdentifier: "backToRaiseFundDetail", sender: nil)
            
        }) // 產生確認按鍵
        inputErrorAlert.addAction(okAction) // 將確認按鍵加入AlertController

        self.present(inputErrorAlert, animated: true, completion: nil) // 顯示Alert
        
    }
    
    func showAlertMessage(title: String, message: String) {
        let inputErrorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert) //產生AlertController
        let okAction = UIAlertAction(title: "確認", style: .default, handler: nil) // 產生確認按鍵
        inputErrorAlert.addAction(okAction) // 將確認按鍵加入AlertController
        self.present(inputErrorAlert, animated: true, completion: nil) // 顯示Alert
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = raiseFundInfo {
            date = data.date
            tempOfRasing = data.raisingAmount
            nameOfTitle = data.title
            creator = data.creator
            stock = data.stock
            rateReturn = data.rateReturn
            txtDate = data.txtDate
            deadlineDate = data.deadlineDate
            editMode = true
            self.navigationItem.title = "Invest"
        }
        
        loadDatas()
        // Do any additional setup after loading the view.
    }
    
    func loadDatas(){
        let docuementId = raiseFundInfo?.date
        let userId = (Auth.auth().currentUser?.email)!
        let ref = db.collection("recordOfFundRaise").document(docuementId!).collection("detail").document(userId).getDocument { (document, error) in
            if let doc = document, doc.exists {
                
                let data = doc.data()
                let tempOfUser = data?["investAmount"] as? Int
                self.tempOfRasing = self.tempOfRasing! - tempOfUser!
                
            } else {
               print("Document does not exist")
            }
         }
    }
    
    // 點擊空白出讓鍵盤消失
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
