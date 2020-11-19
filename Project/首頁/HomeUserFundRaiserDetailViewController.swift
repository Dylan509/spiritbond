//
//  HomeUserFundRaiserDetailViewController.swift
//  spiritbond
//
//  Created by Fung Ying Hei on 13/10/2020.
//

import UIKit
import Firebase
import FirebaseStorage

class HomeUserFundRaiserDetailViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var detailData: UserInfo?
    var photoImageURL: URL?
    var date: String?
    var storageName: String?
    var editMode: Bool = false
    var fundRaiserDatas = [UserInfo]()
    var name = [String]()
    let db = Firestore.firestore()
    let defaultURL = "https://firebasestorage.googleapis.com/v0/b/spiritbond-8d54d.appspot.com/o/photo%2Flee.jpg?alt=media&token=461759c5-5a2f-425e-9384-9bd0d2d443c9"
    
    @IBOutlet weak var tableview: UITableView!
    
    @objc func buttonDone(){
        
        showAlertMessage(title: "提醒", message: "確定是否完成此募資？")
        
    }
    
    func showAlertMessage(title: String, message: String) {
        let inputErrorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert) //產生AlertController
        let okAction = UIAlertAction(title: "確認", style: .default, handler: { action  in
            self.performSegue(withIdentifier: "backToHomeUserFundRaiser", sender: nil)
            
        }) // 產生確認按鍵
        let cancelAction = UIAlertAction(title: "取消", style: .default, handler: nil)
        inputErrorAlert.addAction(okAction)
        inputErrorAlert.addAction(cancelAction)
        
        self.present(inputErrorAlert, animated: true, completion: nil) // 顯示Alert
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.allowsSelection = false

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(buttonDone))

        
    }
    
    @IBAction func unwindToHomeUserFundRaiserDetail(segue: UIStoryboardSegue) {
        
      if let source = segue.source as? HomeUserFundRaiserUploadDataTableViewController, let detailData = source.userInfo{
        
        let userId = Auth.auth().currentUser?.email
        let documentId = detailData.date
        let tempRateReturn = detailData.rateReturn!
        let tempImageURL = detailData.imageURL
        let tempStorageName = detailData.storageName!
        let tempReport = detailData.report!
        let tempdateUpload = detailData.dateUpload!
        let ref = db.collection("userFundRaiser")
        let reff = db.collection("dataBaseFunndRaise").document(documentId)
        let data: [String: Any] = [ "rateReturn": detailData.rateReturn!, "report": detailData.report ?? "", "dateUpload": detailData.dateUpload ?? "1999/05/09"]
        let dataFunndRaise: [String: Any] = [ "rateReturn": detailData.rateReturn!]
        loadForUploadFundRaiseData(documentId: documentId,tempRateReturn: tempRateReturn,tempImageURL: tempImageURL,tempStorageName:tempStorageName, tempReport: tempReport, tempdateUpload: tempdateUpload)
        
        if source.editMode {
            ref.document(userId!).collection("detail").document(documentId).updateData(data, completion: { (error) in
                if let e = error {
                    print("Opps!儲存的時候出了點問題\(e)")
                } else {
                    print("完成！")
                }
            })
            
            reff.updateData(dataFunndRaise, completion: { (error) in
                if let e = error {
                    print("Opps!儲存的時候出了點問題\(e)")
                } else {
                    print("完成！")
                }
            })
        }
             
      }
  }
    
    func loadForUploadFundRaiseData(documentId: String,tempRateReturn: Double,tempImageURL: String?,tempStorageName: String, tempReport: String, tempdateUpload: String){
        
        let ref = db.collection("userFundRaise").getDocuments { (querySnapshot, error) in
            
            if let e = error {
                print("load error\(e)")
            }else{
                if let querySnapshot = querySnapshot {
                    for document in querySnapshot.documents {
                        let data = document.data()
                        
                        if let userID = data["userID"] as? String{
                            self.name.append(userID)
                        }
                        
                    }
                    
                    for count in self.name
                    {
                        
                        let refff = self.db.collection("userFundRaise").document(count).collection("detail")
                        
                        let dataRundRaise: [String: Any] = [ "rateReturn": tempRateReturn, "imageURL": tempImageURL ?? self.defaultURL, "storageName": tempStorageName, "report": tempReport, "dateUpload": tempdateUpload]
                        
                        refff.document(documentId).updateData(dataRundRaise, completion: { (error) in
                            if let e = error {
                                print("Opps!儲存的時候出了點問題\(e)")
                            } else {
                                print("完成！")
                            }
                        })
                        
                    }
                    
           }
        }
      }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fundRaiserUpload" {
            if let data = detailData {
                let destinationVC = segue.destination as! HomeUserFundRaiserUploadDataTableViewController
                destinationVC.userInfo = data
            }
        }
        
    }
}

extension HomeUserFundRaiserDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeUserFundRaiserDetailTableViewCell.self), for: indexPath) as! HomeUserFundRaiserDetailTableViewCell
            cell.icon.image = UIImage(systemName: "flag")
            cell.typeLabel.text = "項目名稱："
            cell.dataLabel.text = detailData?.title ?? ""
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeUserFundRaiserDetailTableViewCell.self), for: indexPath) as! HomeUserFundRaiserDetailTableViewCell
            cell.icon.image = UIImage(systemName: "chart.bar")
            cell.typeLabel.text = "股票："
            cell.dataLabel.text = detailData?.stock ?? ""
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeUserFundRaiserDetailTableViewCell.self), for: indexPath) as! HomeUserFundRaiserDetailTableViewCell
            cell.icon.image = UIImage(systemName: "arrow.up.arrow.down.square")
            cell.typeLabel.text = "預估報酬率："
            cell.dataLabel.text = detailData?.rateReturn?.description ?? ""
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeUserFundRaiserDetailTableViewCell.self), for: indexPath) as! HomeUserFundRaiserDetailTableViewCell
            cell.icon.image = UIImage(systemName: "calendar.badge.plus")
            cell.typeLabel.text = "募資開始時間："
            cell.dataLabel.text = detailData?.txtDate ?? ""
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeUserFundRaiserDetailTableViewCell.self), for: indexPath) as! HomeUserFundRaiserDetailTableViewCell
            cell.icon.image = UIImage(systemName: "calendar.badge.minus")
            cell.typeLabel.text = "募資截止時間："
            cell.dataLabel.text = detailData?.deadlineDate ?? ""
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeUserFundRaiserDetailTableViewCell.self), for: indexPath) as! HomeUserFundRaiserDetailTableViewCell
            cell.icon.image = UIImage(systemName: "dollarsign.circle")
            cell.typeLabel.text = "募資金額："
            cell.dataLabel.text = detailData?.amount?.description ?? ""
            return cell
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
    }
}

