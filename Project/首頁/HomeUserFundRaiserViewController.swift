//
//  HomeUserFundRaiserViewController.swift
//  spiritbond
//
//  Created by Fung Ying Hei on 29/9/2020.
//

import UIKit
import Firebase

class HomeUserFundRaiserViewController: UIViewController {
    
    var currentUser: CurrentUser? = nil
    var currentWorth: Double = 0
    var detailData: UserInfo?
    var fundRaiserDatas = [UserInfo]()
    var name = [String]()
    let db = Firestore.firestore()
    var count: Int = 0
    var timer: Timer?
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFundRaiserData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
        tableview.reloadData()
    }
    
    @IBAction func unwindToHomeUserFundRaiser(segue: UIStoryboardSegue) {
        
        if let source = segue.source as? HomeUserFundRaiserDetailViewController, let fundRaiserDatas = source.detailData{
            
            self.currentUser?.getStockData{ success in
                guard success else { return }
                let rateReturn = Double(fundRaiserDatas.rateReturn!)
                print(rateReturn)
                let finalAmount = Double(fundRaiserDatas.amount!)
                print(finalAmount)
                    if rateReturn > 0.0{
                        let temp10 = Double(finalAmount * rateReturn / 100)
                        print(temp10)
                        self.currentWorth = (self.currentUser?.currentWorth())!
                        print("test1",self.currentWorth)
                        self.currentWorth = (self.currentUser?.currentWorth())! - (temp10)
                        print(self.currentWorth)
                    }else{
                        let temp9 = finalAmount * rateReturn / 100
                        print(temp9)
                        self.currentWorth = (self.currentUser?.currentWorth())!
                        print("test2",self.currentWorth)
                        self.currentWorth = (self.currentUser?.currentWorth())! - (temp9)
                        print(self.currentWorth)
                    }
            }

        let userId = Auth.auth().currentUser?.email
        let documentId = fundRaiserDatas.date
        let ref = db.collection("dataBaseFunndRaise")
        let reff = db.collection("userFundRaiser").document(userId!).collection("detail")
        loadForNoticeFundRaiseData(documentId: documentId)
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
            self.loadForDeleteFundRaiseData(documentId: documentId)
            }


            
            ref.document(documentId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
            reff.document(documentId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }

        
    }
}
    func loadForNoticeFundRaiseData(documentId: String){
        
        let ref2 = db.collection("userFundRaise").getDocuments { (querySnapshot, error) in
            
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
                        let refff2 = self.db.collection("userFundRaise").document(count).collection("detail")
                        
                        refff2.document(documentId).getDocument { (document, error) in
                            if let document = document, document.exists {
                                let data = document.data()
                                let refff3 = self.db.collection("userNotice").document(count).collection("detail")
                                
                                refff3.document(documentId).setData(data!){(error) in
                                    if let e = error {
                                        print("Opps!儲存的時候出了點問題\(e)")
                                    } else {
                                        print("完成！")
                                    }
                                }
                                
                            } else {
                               print("Document does not exist")
                            }
                         }
                    }
                    
           }
        }
      }
    }
    
    func loadForDeleteFundRaiseData(documentId: String){
        
        print(documentId)
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
                        
                        refff.document(documentId).delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                    }
                    
           }
        }
      }
    }
 
    func loadFundRaiserData() {
        let userId = (Auth.auth().currentUser?.email)!
        let ref =
            db.collection("userFundRaiser").document(userId).collection("detail")
            .getDocuments { (querySnapshot, error) in
            self.fundRaiserDatas = []
            if let e = error {
                print("Opps!儲存的時候出了點問題\(e)")
            } else {
                if let querySnapshot = querySnapshot {
                    for doc in querySnapshot.documents {
                        let data = doc.data()
                
                        if let title = data["title"] as? String, let amount =
                            data["totalAmount"] as? Int, let stock = data["stock"] as? String, let rateReturn = data["rateReturn"] as? Double, let txtDate = data["txtDate"] as? String , let deadlineDate = data["deadlineDate"] as? String, let date = data["date"] as? String{
                            let newFundRaiser = UserInfo(title: title, amount: amount, stock: stock, rateReturn: rateReturn, txtDate: txtDate, deadlineDate: deadlineDate, date: date)
                            self.fundRaiserDatas.append(newFundRaiser)
                            
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
        if segue.identifier == "showRaiserDetail" {
            if let indexPath = tableview.indexPathForSelectedRow{
                let destinationVC = segue.destination as!
                    HomeUserFundRaiserDetailViewController
                destinationVC.detailData = fundRaiserDatas[indexPath.row]
            }
        }
        if segue.identifier == "manageFund" {
            if let indexPath = tableview.indexPathForSelectedRow{
                let destinationVC = segue.destination as! manageFund
                destinationVC.detailData2 = fundRaiserDatas[indexPath.row]
            }
        }
    }
    

}



extension HomeUserFundRaiserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fundRaiserDatas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeUserFundRaiserTableViewCell.self), for: indexPath) as! HomeUserFundRaiserTableViewCell
        cell.iconAmountImageView.image = UIImage(systemName: "dollarsign.circle")
        cell.nameLabel.text = fundRaiserDatas[indexPath.row].title
        cell.amountLabel.text = fundRaiserDatas[indexPath.row].amount?.description

            return cell
    }
    
}
