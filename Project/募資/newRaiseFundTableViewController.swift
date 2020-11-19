//
//  newRaiseFundTableViewController.swift
//  spiritbond
//
//  Created by lim jia le on 2020/9/24.
//

import UIKit
import Firebase

class newRaiseFundTableViewController: UITableViewController {
    
    @IBOutlet weak var photoimageView: UIImageView!
    @IBOutlet weak var titletextField: UITextField!{
        didSet {
            titletextField.delegate = self
            titletextField.tag = 1
            titletextField.becomeFirstResponder()
        }
    }
    @IBOutlet weak var amounttextField: UITextField! {
        didSet {
            amounttextField.delegate = self
            amounttextField.tag = 2
        }
    }
    @IBOutlet weak var ratereturnTextField: UITextField! {
        didSet {
            ratereturnTextField.delegate = self
            ratereturnTextField.tag = 3
        }
    }
    @IBOutlet weak var stocktextField: UITextField! {
        didSet {
            stocktextField.delegate = self
            stocktextField.tag = 4
        }
    }
    @IBOutlet weak var indextextField: UITextField! {
        didSet {
            indextextField.delegate = self
            indextextField.tag = 5
        }
    }
    @IBOutlet weak var ideastextField: UITextField! {
        didSet {
            ideastextField.delegate = self
            ideastextField.tag = 6
        }
    }
    @IBOutlet weak var typepickerView: UIPickerView! {
        didSet {
            typepickerView.delegate = self
            typepickerView.dataSource = self
        }
    }
    @IBOutlet weak var typeofUserTextView: UITextView!
    @IBOutlet weak var txtdatePicker: UITextField!
    @IBOutlet weak var deadlinedatePicker: UITextField!
    
    let datePicker = UIDatePicker()
    let pickerView = UIPickerView()
    var raiseFundInfo : RaiseFundInfo?
    var typeRaiseFund = TypeRaiseFund()
    var photoImageURL: URL?
    var date: String?
    var storageName: String?
    var editMode: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = raiseFundInfo {
            titletextField.text = data.title
            amounttextField.text = data.amount?.description
            ratereturnTextField.text = data.rateReturn?.description
            stocktextField.text = data.stock
            indextextField.text = data.index
            ideastextField.text = data.ideas
            typeofUserTextView.text = data.typeOfUser
            txtdatePicker.text = data.txtDate
            deadlinedatePicker.text = data.deadlineDate
            photoimageView.image = UIImage(data: data.image!)
            photoimageView.contentMode = .scaleToFill
            photoLayout(imageView: photoimageView)
            photoImageURL = URL(string: data.imageURL!)
            editMode = true
        }
        
        showDatePicker()
        showDeadlineDatePicker()
        
    }
    // 點擊空白出讓鍵盤消失
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // 判斷必填項目是否有空白的情況
        if titletextField.text == "" || amounttextField.text == "" || ratereturnTextField.text == "" || stocktextField.text == "" || txtdatePicker.text == "" || typeofUserTextView.text == "" || deadlinedatePicker.text == "" {
            let alert = UIAlertController(title: "Oops!有少資料喔！", message: "名稱！募資金額！預估報酬率!股票！種類！時間為必填項目喔！", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
            return
        }

        let title = titletextField.text ?? ""
        let amount = Int(amounttextField.text!) ?? 0
        let rasingAmount = 0
        let rateReturn = Double(ratereturnTextField.text!) ?? 0.0
        let stock = stocktextField.text ?? ""
        let index = indextextField.text ?? ""
        let ideas = ideastextField.text ?? ""
        let typeOfUser = typeofUserTextView.text ?? ""
        let txtDate = txtdatePicker.text ?? ""
        let deadlineDate = deadlinedatePicker.text ?? ""
        let image = photoimageView.image?.pngData()
        let creator = Auth.auth().currentUser?.email
        if date == nil {
            date = String(Date().timeIntervalSince1970)
        }
        if photoImageURL?.absoluteString == nil {
            storageName = ""
        }

        raiseFundInfo = RaiseFundInfo(creator: creator, title: title, amount: amount, rateReturn: rateReturn, stock: stock, index: index, ideas: ideas,image: image, typeOfUser: typeOfUser, txtDate: txtDate, imageURL: photoImageURL?.absoluteString, storageName: storageName!, date: date!, raisingAmount: rasingAmount, deadlineDate: deadlineDate )
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
    
    // 選擇picker後執行的內容
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedData = typeRaiseFund.type[row]
        typeofUserTextView?.text = selectedData
        }


    func showDatePicker()
    {
               
        //Formate Date
        datePicker.datePickerMode = .date

        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        txtdatePicker.inputAccessoryView = toolbar
        txtdatePicker.inputView = datePicker
        
    }
    
    func showDeadlineDatePicker()
    {
               
        //Formate Date
        datePicker.datePickerMode = .date

        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(donedeadlinedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        deadlinedatePicker.inputAccessoryView = toolbar
        deadlinedatePicker.inputView = datePicker
        
    }

    @objc func donedatePicker()
    {

    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    txtdatePicker.text = formatter.string(from: datePicker.date)
    self.view.endEditing(true)
    }
    
    @objc func donedeadlinedatePicker()
    {

    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    deadlinedatePicker.text = formatter.string(from: datePicker.date)
    self.view.endEditing(true)
    }

    @objc func cancelDatePicker()
    {
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
            photoimageView.image = selectedImage
            photoimageView.contentMode = .scaleToFill
            photoimageView.clipsToBounds = true
        }
        
        // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
        let uniqueString = UUID().uuidString
        storageName = "\(uniqueString).jpg"
        
        // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
        if let image = photoimageView.image {
            
            let storageRef = Storage.storage().reference().child("Upload_photo").child("\(uniqueString).jpg")
            if let uploadData = image.jpegData(compressionQuality: 0.3) {
                storageRef.putData(uploadData, metadata: nil) { (data, error) in
                    if error != nil {
                        print("Error: \(error!.localizedDescription)")
                        return
                    }
                    storageRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            return
                        }
                        print("Photo Url: \(downloadURL)")
                        self.photoImageURL = downloadURL
                    }
                }
            }
            
            print("\(uniqueString), \(image)")
        }
        
        // 選擇照片後設定auto layout並設定isActive屬性為true來啟動設定
        photoLayout(imageView: photoimageView)
        
        dismiss(animated: true, completion: nil)
    }
    
    func photoLayout(imageView: UIImageView) {
        let leadingConstraint = NSLayoutConstraint(item: photoimageView as Any, attribute: .leading, relatedBy: .equal, toItem: photoimageView.superview, attribute: .leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: photoimageView as Any, attribute: .trailing, relatedBy: .equal, toItem: photoimageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: photoimageView as Any, attribute: .top, relatedBy: .equal, toItem: photoimageView.superview, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: photoimageView as Any, attribute: .bottom, relatedBy: .equal, toItem: photoimageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true
    }
}
