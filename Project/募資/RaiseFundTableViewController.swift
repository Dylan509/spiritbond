//
//  RaiseFundTableViewController.swift
//  spiritbond
//
//  Created by lim jia le on 2020/9/24.
//

import UIKit
import Firebase

class RaiseFundTableViewController: UITableViewController {
    
    var detailData: RaiseFundInfo?
    var raiseFundDatas = [RaiseFundInfo]()
    let db = Firestore.firestore()
    var temp1 = ""
    let defaultURL = "https://firebasestorage.googleapis.com/v0/b/spiritbond-8d54d.appspot.com/o/photo%2Flee.jpg?alt=media&token=461759c5-5a2f-425e-9384-9bd0d2d443c9"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        loadRaiseFundData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return raiseFundDatas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "raiseFundCell", for: indexPath) as!
            RaiseFundTableViewCell
        cell.raisefundTitleLabel.text = raiseFundDatas[indexPath.row].title
        cell.raisefundStockLabel.text = raiseFundDatas[indexPath.row].stock
        if let image = raiseFundDatas[indexPath.row].image {
            cell.raisefundImageView.image = UIImage(data: image)
        }
        return cell
    }
    
    @IBAction func unwinToNewRaiseFundTableView(segue: UIStoryboardSegue) {
        
        if let source = segue.source as? newRaiseFundTableViewController, let raiseFundInfo = source.raiseFundInfo, let userId = Auth.auth().currentUser?.email  {
            let docuementId = raiseFundInfo.date
            let ref = db.collection("dataBaseFunndRaise")
            let reff = db.collection("recordOfFundRaise")
            let refff = db.collection("userFundRaiser")
            let data = ["creator": raiseFundInfo.creator!, "title": raiseFundInfo.title!, "amount": raiseFundInfo.amount!, "rateReturn": raiseFundInfo.rateReturn!, "stock": raiseFundInfo.stock!, "index": raiseFundInfo.index!, "ideas": raiseFundInfo.ideas!, "typeOfUser": raiseFundInfo.typeOfUser!, "txtDate": raiseFundInfo.txtDate!, "imageURL": raiseFundInfo.imageURL ?? defaultURL, "date": docuementId, "storageName": raiseFundInfo.storageName!, "rasingAmount": raiseFundInfo.raisingAmount!, "deadlineDate": raiseFundInfo.deadlineDate! ] as [String : Any]
            let dataRecord = ["creator": userId, "rasingAmount": raiseFundInfo.raisingAmount!] as [String : Any]
            let dataRaiser = ["title": raiseFundInfo.title!,"totalAmount": raiseFundInfo.raisingAmount!, "stock": raiseFundInfo.stock!, "rateReturn": raiseFundInfo.rateReturn!, "txtDate": raiseFundInfo.txtDate!, "deadlineDate": raiseFundInfo.deadlineDate!,  "date": docuementId ] as [String : Any]
            if source.editMode {
                ref.document(docuementId).updateData(data, completion: { (error) in
                    if let e = error {
                        print("Opps!儲存的時候出了點問題\(e)")
                    } else {
                        print("完成！")
                    }
                })
            } else {
                ref.document(docuementId).setData(data) { (error) in
                    if let e = error {
                        print("Opps!儲存的時候出了點問題\(e)")
                    } else {
                        print("完成！")
                    }
                }
                reff.document(docuementId).setData(dataRecord) {(error) in
                    if let e = error {
                        print("Opps!儲存的時候出了點問題\(e)")
                    }else {
                        print("完成！")
                    }
                }
                refff.document(userId).collection("detail").document(docuementId).setData(dataRaiser) {(error) in
                    if let e = error {
                        print("Opps!儲存的時候出了點問題\(e)")
                    }else {
                        print("完成！")
                    }
                }
            }
        }
    }
    
    @IBAction func unwindToRaiseFundInvestViewController(segue: UIStoryboardSegue) {
        
        if let source = segue.source as? RaiseFundInvestViewController, let raiseFundInfo = source.raiseFundInfo, let userId = Auth.auth().currentUser?.email, let tempCreator = raiseFundInfo.creator  {
            let docuementId = raiseFundInfo.date
            let ref = db.collection("dataBaseFunndRaise")
            let reff = db.collection("recordOfFundRaise")
            let refff = db.collection("userFundRaise")
            let reffff = db.collection("userFundRaiser")
            let data: [String: Any] = ["rasingAmount": raiseFundInfo.raisingAmount!]
            let dataRecord: [String : Any] = ["Investor": userId, "investAmount": raiseFundInfo.temp!]
            let dataRacordTotal: [String : Any] = ["rasingAmount": raiseFundInfo.raisingAmount!]
            let dataRaise: [String : Any] = ["title": raiseFundInfo.title!, "amount": raiseFundInfo.temp!, "stock": raiseFundInfo.stock!, "rateReturn": raiseFundInfo.rateReturn!, "txtDate": raiseFundInfo.txtDate!, "deadlineDate": raiseFundInfo.deadlineDate! , "date": raiseFundInfo.date, "imageURL": temp1, "storageName": temp1, "report": temp1, "dateUpload": temp1]
            let dataRaiser:[String : Any] = ["title": raiseFundInfo.title!, "totalAmount": raiseFundInfo.raisingAmount!, "stock": raiseFundInfo.stock!, "rateReturn": raiseFundInfo.rateReturn!, "txtDate": raiseFundInfo.txtDate!, "deadlineDate": raiseFundInfo.deadlineDate!, "date": raiseFundInfo.date ]
            let dataRaiseUser: [String : Any] = ["userID" : userId]
            if source.editMode {
                ref.document(docuementId).updateData(data, completion: { (error) in
                    if let e = error {
                        print("Opps!儲存的時候出了點問題\(e)")
                    } else {
                        print("完成！")
                    }
                })
                reff.document(docuementId).collection("detail").document(userId).setData(dataRecord){(error) in
                    if let e = error {
                        print("Opps!儲存的時候出了點問題\(e)")
                    } else {
                        print("完成！")
                    }
                }
                refff.document(userId).collection("detail").document(docuementId).setData(dataRaise){(error) in
                    if let e = error {
                        print("Opps!儲存的時候出了點問題\(e)")
                    }else {
                        print("完成！")
                    }
                }
                
                refff.document(userId).setData(dataRaiseUser){(error) in
                    if let e = error {
                        print("Opps!儲存的時候出了點問題\(e)")
                    }else {
                        print("完成！")
                    }
                }
                
                refff.document(userId).collection("detail").document(docuementId).updateData(dataRaise, completion: { (error) in
                    if let e = error {
                        print("Opps!儲存的時候出了點問題\(e)")
                    } else {
                        print("完成！")
                    }
                })
                reff.document(docuementId).updateData(dataRacordTotal, completion: { (error) in
                    if let e = error {
                        print("Opps!儲存的時候出了點問題\(e)")
                    } else {
                        print("完成！")
                    }
                })
                reffff.document(tempCreator).collection("detail").document(docuementId).updateData(dataRaiser, completion: { (error) in
                    if let e = error {
                        print("Opps!儲存的時候出了點問題\(e)")
                    } else {
                        print("完成！")
                    }
                })
                
            } else {
                ref.document(docuementId).setData(data) { (error) in
                    if let e = error {
                        print("Opps!儲存的時候出了點問題\(e)")
                    } else {
                        print("完成！")
                    }
                }
            }
        }
    }
    
    func loadRaiseFundData() {
        let ref = db.collection("dataBaseFunndRaise")
        ref.order(by: "date", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                self.raiseFundDatas = []
                if let e = error {
                    print("Opps!儲存的時候出了點問題\(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            
                            if let title = data["title"] as? String, let amount = data["amount"] as? Int, let rateReturn = data["rateReturn"] as? Double, let stock = data["stock"] as? String, let index = data["index"] as? String, let ideas = data["ideas"] as? String, let typeOfUser = data["typeOfUser"] as? String, let txtDate = data["txtDate"] as? String, let imageURL = data["imageURL"] as? String, let date = data["date"] as? String, let storageName = data["storageName"] as? String, let rasingAmount = data["rasingAmount"] as? Int, let creator = data["creator"] as? String, let deadlineDate = data["deadlineDate"] as? String {
                                if let imageUrl = URL(string: imageURL) {
                                    let task = URLSession.shared.dataTask(with: imageUrl, completionHandler: {(data, response, error) in
                                    if let e = error {
                                            print("\(e)")
                                    }else if let imageData = data {
                                        let newRaiseFundDatas = RaiseFundInfo(creator: creator, title: title, amount: amount, rateReturn: rateReturn, stock: stock, index: index, ideas: ideas, image: imageData, typeOfUser: typeOfUser, txtDate: txtDate , imageURL: imageURL, storageName: storageName, date: date, raisingAmount: rasingAmount,deadlineDate: deadlineDate)
                                            self.raiseFundDatas.append(newRaiseFundDatas)
                                            
                                            DispatchQueue.main.async {
                                                self.tableView.reloadData()
                                            }
                                        }
                                    })
                                    task.resume()
                                }
                            }
                        }
                    }
                                                    
            }
        }
}
                                    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRaiseFundDetail" {
            if let indexPath = tableView.indexPathForSelectedRow{
                let destinationVC = segue.destination as!
                    RaiseFundDetailViewController
                destinationVC.detailData = raiseFundDatas[indexPath.row]
            }
        }
    }
    
}
