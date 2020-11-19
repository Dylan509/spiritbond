//
//  HomeUserFundRaiseViewController.swift
//  spiritbond
//
//  Created by Fung Ying Hei on 29/9/2020.
//

import UIKit
import Firebase

class HomeUserFundRaiseViewController: UIViewController {
    
    var detailData: UserInfo?
    var fundRaiseDatas = [UserInfo]()
    let db = Firestore.firestore()
    let defaultURL = "https://firebasestorage.googleapis.com/v0/b/spiritbond-8d54d.appspot.com/o/photo%2Flee.jpg?alt=media&token=461759c5-5a2f-425e-9384-9bd0d2d443c9"
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFundRaiseData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
        tableview.reloadData()
    }
    
    func loadFundRaiseData() {
        let userId = (Auth.auth().currentUser?.email)!
        let ref = db.collection("userFundRaise").document(userId).collection("detail").getDocuments { (querySnapshot, error) in
            self.fundRaiseDatas = []
            if let e = error {
                print("Opps!儲存的時候出了點問題\(e)")
            } else {
                if let querySnapshot = querySnapshot {
                    for doc in querySnapshot.documents {
                        let data = doc.data()
                
                        if let title = data["title"] as? String, let amount = data["amount"] as? Int, let stock = data["stock"] as? String, let rateReturn = data["rateReturn"] as? Double, let txtDate = data["txtDate"] as? String, let deadlineDate = data["deadlineDate"] as? String, let date = data["date"] as? String, let imageURL = data["imageURL"] as? String, let storageName = data["storageName"] as? String, let report = data["report"] as? String, let dateUpload = data["dateUpload"] as? String{
                            let newFundRaise = UserInfo(title: title, amount: amount, stock: stock, rateReturn: rateReturn, txtDate: txtDate, deadlineDate:deadlineDate, date: date, imageURL: imageURL, storageName: storageName, report: report, dateUpload: dateUpload)
                            self.fundRaiseDatas.append(newFundRaise)
                                DispatchQueue.main.async {
                                    self.tableview.reloadData()
                                    }
                            }
                        }
                    }
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRaiseDetail" {
            if let indexPath = tableview.indexPathForSelectedRow{
                let destinationVC = segue.destination as!
                    HomeUserFundRaiseDetailViewController
                destinationVC.detailData = fundRaiseDatas[indexPath.row]
            }
        }
    }
    
}

extension HomeUserFundRaiseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fundRaiseDatas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeUserFundRaiseTableViewCell.self), for: indexPath) as! HomeUserFundRaiseTableViewCell
        cell.iconAmountImageView.image = UIImage(systemName: "dollarsign.circle")
        cell.nameLabel.text = fundRaiseDatas[indexPath.row].title
        cell.amountLabel.text = fundRaiseDatas[indexPath.row].amount?.description

        return cell
    }
}
