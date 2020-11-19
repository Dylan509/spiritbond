//
//  HomeUserNoticeViewController.swift
//  spiritbond
//
//  Created by Fung Ying Hei on 1/11/2020.
//

import UIKit
import Firebase

class HomeUserNoticeViewController: UIViewController {

    let db = Firestore.firestore()
    var userNotice = [UserInfo]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNotice()
    }
    
    func loadNotice(){
        let documentId = Auth.auth().currentUser?.email
        let ref = db.collection("userNotice").document(documentId!).collection("detail").getDocuments { (querySnapshot, error) in
            self.userNotice = []
            if let e = error {
                print("Opps!儲存的時候出了點問題\(e)")
            } else {
                if let querySnapshot = querySnapshot {
                    for doc in querySnapshot.documents {
                        let data = doc.data()
                
                        if let amount = data["amount"] as? Int, let rateReturn = data["rateReturn"] as? Double , let date = data["date"] as? String, let title = data["title"] as? String{
                            let newNotice = UserInfo(title: title, amount: amount, rateReturn: rateReturn, date: date)
                                self.userNotice.append(newNotice)
                            
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                        }
                    }
                }
            }
        }
        
    }
}

extension HomeUserNoticeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userNotice.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeUserNoticeTableViewCell.self), for: indexPath) as! HomeUserNoticeTableViewCell
        let amount = userNotice[indexPath.row].amount?.description ?? ""
        let rateReturn = userNotice[indexPath.row].rateReturn?.description ?? ""
        let title = userNotice[indexPath.row].title
        cell.iconimageView.image = UIImage(systemName: "lightbulb")
        cell.noticelabel.text = "你以$" + amount + " 投資的" + title! + " 項目以" + rateReturn + "報酬率完成此募資！！！"
    
            return cell
    }
}
