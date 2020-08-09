//
//  newRaiseFundViewController.swift
//  SpiritBond
//
//  Created by Fung Ying Hei on 31/7/2020.
//  Copyright © 2020 茂木匠. All rights reserved.
//

import UIKit
import Firebase

class newRaiseFundViewController: UIViewController {

        @IBOutlet weak var photoImageView: UIImageView!
        @IBOutlet weak var titleTextField: UITextField! {
            didSet {
                titleTextField.delegate = self
                titleTextField.tag = 1
                titleTextField.becomeFirstResponder()
            }
        }

        @IBOutlet weak var amountTextField: UITextField! {
            didSet {
                amountTextField.delegate = self
                amountTextField.tag = 2
            }
        }
    
        @IBOutlet weak var rateReturnTextField: UITextField! {
            didSet {
                rateReturnTextField.delegate = self
                rateReturnTextField.tag = 3
            }
        }
    
        @IBOutlet weak var stockTextField: UITextField! {
            didSet {
                stockTextField.delegate = self
                stockTextField.tag = 4
            }
        }
    
        @IBOutlet weak var indexTextField: UITextField! {
            didSet {
                indexTextField.delegate = self
                indexTextField.tag = 5
            }
        }
    
        @IBOutlet weak var ideasTextField: UITextField! {
            didSet {
                ideasTextField.delegate = self
                ideasTextField.tag = 6
            }
        }

        @IBOutlet weak var typePickerView: UIPickerView! {
            didSet {
                typePickerView.delegate = self
                typePickerView.dataSource = self
            }
        }
        var raiseFundInfo : RaiseFundInfo?
        var type = TypeRaiseFund()
        var photoImageURL: URL?
        var date: String?
        var storageName: String?
        

        override func viewDidLoad() {
            super.viewDidLoad()
            if let data = raiseFundInfo {
                titleTextField.text = data.title
                amountTextField.text = data.amount?.description
                rateReturnTextField.text = data.rateReturn?.description
                stockTextField.text = data.stock
                indexTextField.text = data.index
                ideasTextField.text = data.ideas
            }
            
            
            
        }
        
        // 點擊空白出讓鍵盤消失
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
        }

        // MARK: - Navigation

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // 判斷必填項目是否有空白的情況
            if titleTextField.text == "" || amountTextField.text == "" || rateReturnTextField.text == ""{
                let alert = UIAlertController(title: "Oops!有少資料喔！", message: "標題！募資金額！報酬率為必填項目喔！", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(alertAction)
                present(alert, animated: true, completion: nil)
                return


            }

            let title = titleTextField.text ?? ""
            let amount = Int(amountTextField.text!) ?? 0
            let rateReturn = Double(rateReturnTextField.text!) ?? 0.0
            let stock = stockTextField.text ?? ""
            let index = indexTextField.text ?? ""
            let ideas = ideasTextField.text ?? ""
            if date == nil {
                date = String(Date().timeIntervalSince1970)
            }
            if photoImageURL?.absoluteString == nil {
                storageName = ""
            }

            raiseFundInfo = RaiseFundInfo(title: title, amount: amount, rateReturn: rateReturn, stock: stock, index: index, ideas: ideas)
        }

    }

    extension newRaiseFundViewController: UIPickerViewDelegate, UIPickerViewDataSource {
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return type.type.count
        }
        
    }

    extension newRaiseFundViewController: UITextFieldDelegate {
        // 按return鍵後跳到下一個textfiled
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if let nextTextField = view.viewWithTag(textField.tag + 1) {
                textField.resignFirstResponder()
                nextTextField.becomeFirstResponder()
            }
            return true
        }
    }

