//
//  RaiseFundTableViewController.swift
//  SpiritBond
//
//  Created by Fung Ying Hei on 31/7/2020.
//  Copyright © 2020 茂木匠. All rights reserved.
//

import UIKit
import Firebase

class RaiseFundTableViewController: UITableViewController {
    
    var detailData: RaiseFundInfo?
    var raiseFundDatas = [RaiseFundInfo]()
    let db = Firestore.firestore()
    let defaultURL = "https://firebasestorage.googleapis.com/v0/b/find-cafe-8c443.appspot.com/o/804341E1-77D3-4E25-9372-781D06A7E8A3.jpg?alt=media&token=cb023511-760f-45f7-8665-5b8dd0f4c2fc"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(red: 229 / 255, green: 216 / 255, blue: 191 / 255, alpha: 1)
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
        cell.raiseFundTitleLabel.text = raiseFundDatas[indexPath.row].title
        cell.raiseFundStockLabel.text = raiseFundDatas[indexPath.row].stock
        if let image = raiseFundDatas[indexPath.row].image {
            cell.raiseFundImageView.image = UIImage(data: image)
        }
        
        cell.backgroundColor = UIColor(red: 229 / 255, green: 216 / 255, blue: 191 / 255, alpha: 1)
        return cell
    }
    
    @IBAction func unwinToNewRaiseFundTableView(segue: UIStoryboardSegue) {
        
        if let source = segue.source as? newRaiseFundTableViewController, let raiseFundInfo = source.raiseFundInfo, let userId = Auth.auth().currentUser?.email  {
            let docuementId = raiseFundInfo.date
            let ref = db.collection("dataBaseFunndRaise")
            let data = ["creator": userId, "title": raiseFundInfo.title!, "amount": raiseFundInfo.amount!, "rateReturn": raiseFundInfo.rateReturn!, "stock": raiseFundInfo.stock!, "index": raiseFundInfo.index!, "ideas": raiseFundInfo.ideas!, "imageURL": raiseFundInfo.imageURL ?? defaultURL, "date": docuementId, "storageName": raiseFundInfo.storageName! ] as [String : Any]
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
            }

        }
        
    }
    
    func loadRaiseFundData() {
        let userId = Auth.auth().currentUser?.email
        let ref = db.collection("dataBaseFunndRaise")
        ref.order(by: "date", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                self.raiseFundDatas = []
                if let e = error {
                    print("TOpps!儲存的時候出了點問題\(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            
                            if let title = data["title"] as? String, let amount = data["amount"] as? Int, let rateReturn = data["rateReturn"] as? Double, let stock = data["stock"] as? String, let index = data["index"] as? String, let ideas = data["ideas"] as? String, let imageURL = data["imageURL"] as? String, let date = data["date"] as? String, let storageName = data["storageName"] as? String {
                                if let imageUrl = URL(string: imageURL) {
                                    let task = URLSession.shared.dataTask(with: imageUrl, completionHandler: {(data, response, error) in
                                    if let e = error {
                                            print("\(e)")
                                    }else if let imageData = data {
                                        let newRaiseFundDatas = RaiseFundInfo(title: title, amount: amount, rateReturn: rateReturn, stock: stock, index: index, ideas: ideas, image: imageData, imageURL: imageURL, storageName: storageName, date: date)
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
                    RaiseFundTableViewController
                destinationVC.detailData = raiseFundDatas[indexPath.row]
                print(raiseFundDatas)
            }
        }
    }
    
}
    
    
