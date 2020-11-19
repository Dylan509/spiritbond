//
//  HomeUserFundRaiserUploadDataTableViewController.swift
//  spiritbond
//
//  Created by Fung Ying Hei on 30/10/2020.
//

import UIKit
import Firebase

class HomeUserFundRaiserUploadDataTableViewController: UITableViewController{
    
    @IBOutlet weak var photoimageView: UIImageView!
    @IBOutlet weak var reportTextField: UITextField!{
        didSet {
            reportTextField.tag = 1
        }
    }
    @IBOutlet weak var ratereturnTextField: UITextField! {
        didSet {
            ratereturnTextField.tag = 2
        }
    }
    
    var photoImageURL: URL?
    var date: String?
    var storageName: String?
    var userInfo : UserInfo?
    var editMode: Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = userInfo {
            reportTextField.text = data.report
            ratereturnTextField.text = data.rateReturn?.description
            date = data.date
            editMode = true
        }
        // Do any additional setup after loading the view.
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let rateReturn = Double(ratereturnTextField.text!) ?? 0.0
        let report = reportTextField.text ?? ""
        let image = photoimageView.image?.pngData()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateUpload = dateFormatter.string(from: Date())
        if date == nil {
            date = String(Date().timeIntervalSince1970)
        }
        if photoImageURL?.absoluteString == nil {
            storageName = ""
        }

        userInfo = UserInfo(rateReturn: rateReturn,date: date!, imageURL: photoImageURL?.absoluteString, storageName: storageName!, image: image, report: report, dateUpload: dateUpload)
    }
    
    @IBAction func buttonUpload(_ sender: UIButton) {
        
        showAlertOk(title: "提醒", message: "上傳完成！！！")
    }
    
    func showAlertOk(title: String, message: String) {
        let inputErrorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert) //產生AlertController
        let okAction = UIAlertAction(title: "確認", style: .default, handler: { action  in
            self.performSegue(withIdentifier: "backToHomeUserFundRaiserDetail", sender: nil)
            
        }) // 產生確認按鍵
        inputErrorAlert.addAction(okAction) // 將確認按鍵加入AlertController

        self.present(inputErrorAlert, animated: true, completion: nil) // 顯示Alert
        
    }

}

extension HomeUserFundRaiserUploadDataTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
