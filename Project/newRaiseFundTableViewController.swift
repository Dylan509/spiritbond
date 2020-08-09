//
//  newRaiseFundTableViewController.swift
//  SpiritBond
//
//  Created by Fung Ying Hei on 31/7/2020.
//  Copyright © 2020 茂木匠. All rights reserved.
//

import UIKit
import Firebase

class newRaiseFundTableViewController: UITableViewController {
    
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
    
        @IBOutlet weak var txtDatePicker: UITextField!
    
        let datePicker = UIDatePicker()

    
        var raiseFundInfo : RaiseFundInfo?
        var typeRaiseFund = TypeRaiseFund()
        var photoImageURL: URL?
        var date: String?
        var storageName: String?
        var editMode: Bool = false
        

        override func viewDidLoad() {
            super.viewDidLoad()
            if let data = raiseFundInfo {
                titleTextField.text = data.title
                amountTextField.text = data.amount?.description
                rateReturnTextField.text = data.rateReturn?.description
                stockTextField.text = data.stock
                indexTextField.text = data.index
                ideasTextField.text = data.ideas
                editMode = true
            }
            
            showDatePicker()
            
        }
        
        // 點擊空白出讓鍵盤消失
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
        }

        // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // 判斷必填項目是否有空白的情況
            if titleTextField.text == "" || amountTextField.text == "" || rateReturnTextField.text == "" || stockTextField.text == "" || txtDatePicker.text == "" {
                let alert = UIAlertController(title: "Oops!有少資料喔！", message: "標題！募資金額！報酬率!股票！種類！時間為必填項目喔！", preferredStyle: .alert)
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
            let image = photoImageView.image?.pngData()
            if date == nil {
                date = String(Date().timeIntervalSince1970)
            }
            if photoImageURL?.absoluteString == nil {
                storageName = ""
            }

        raiseFundInfo = RaiseFundInfo(title: title, amount: amount, rateReturn: rateReturn, stock: stock, index: index, ideas: ideas,image: image, imageURL: photoImageURL?.absoluteString, storageName: storageName!, date: date!)
        }

    }

    extension newRaiseFundTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return typeRaiseFund.type.count
        }
        
        // 顯示cloumn的內容
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return typeRaiseFund.type[row]
        }
        
        func showDatePicker(){
           //Formate Date
           datePicker.datePickerMode = .date

          //ToolBar
          let toolbar = UIToolbar();
          toolbar.sizeToFit()
          let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
         let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

         txtDatePicker.inputAccessoryView = toolbar
         txtDatePicker.inputView = datePicker

        }

         @objc func donedatePicker(){

          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"
          txtDatePicker.text = formatter.string(from: datePicker.date)
          self.view.endEditing(true)
        }

        @objc func cancelDatePicker(){
           self.view.endEditing(true)
         }
        
    }

    extension newRaiseFundTableViewController: UITextFieldDelegate {
        // 按return鍵後跳到下一個textfiled
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if let nextTextField = view.viewWithTag(textField.tag + 1) {
                textField.resignFirstResponder()
                nextTextField.becomeFirstResponder()
            }
            return true
        }
    }

extension newRaiseFundTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.row == 0 {
            let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
            // 使用相機
            let cameraAction = UIAlertAction(title: "相機", style: .default) { (action) in
                // 先判斷是否被允許使用相簿
                 if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                   let imagePicker = UIImagePickerController()
                                   imagePicker.allowsEditing = false
                                   imagePicker.sourceType = .camera
                                   imagePicker.delegate = self
                                   self.present(imagePicker, animated: true, completion: nil)
                }
            }

            // 使用相簿
            let photoLibraryAction = UIAlertAction(title: "相簿", style: .default) { (action) in
                // 先判斷是否被允許取用相簿
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.delegate = self
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
            
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            present(photoSourceRequestController, animated: true, completion: nil)
        }

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleToFill
            photoImageView.clipsToBounds = true
        }
        
        // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
        let uniqueString = UUID().uuidString
        storageName = "\(uniqueString).jpg"
        
        // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
        if let image = photoImageView.image {
            
            if let uploadData = image.jpegData(compressionQuality: 0.3) {
                
                
            }
            
            print("\(uniqueString), \(image)")
        }
        
        // 選擇照片後設定auto layout並設定isActive屬性為true來啟動設定
        photoLayout(imageView: photoImageView)
        
        dismiss(animated: true, completion: nil)
    }
    
    func photoLayout(imageView: UIImageView) {
        let leadingConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .leading, relatedBy: .equal, toItem: photoImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .trailing, relatedBy: .equal, toItem: photoImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .top, relatedBy: .equal, toItem: photoImageView.superview, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .bottom, relatedBy: .equal, toItem: photoImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true
    }
}
