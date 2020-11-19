//
//  RaiseFundInvestorViewController.swift
//  spiritbond
//
//  Created by lim jia le on 2020/9/24.
//

import UIKit
import Firebase

class RaiseFundInvestorViewController: UIViewController  {
    
    var raiseFundInfo : RaiseFundInfo?
    var date: String?
    var raiseFundDatas = [RecordOfRasing]()
    var tempStr: String?
    let db = Firestore.firestore()
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let dataRecord = raiseFundInfo {
            date = dataRecord.date
        }
        
        loadRecordOfFundRaiseData()
 
    }
    
    func loadRecordOfFundRaiseData() {
        let docuementId = raiseFundInfo?.date
        let ref = db.collection("recordOfFundRaise").document(docuementId!).collection("detail").getDocuments { (querySnapshot, error) in
            self.raiseFundDatas = []
            if let e = error {
                print("Opps!儲存的時候出了點問題\(e)")
            } else {
                if let querySnapshot = querySnapshot {
                    for doc in querySnapshot.documents {
                        let data = doc.data()
                
                        if let investor = data["Investor"] as? String, let investAmount = data["investAmount"] as? Int {
                            let newRaiseFundDatas = RecordOfRasing(investor: investor, investorAmount: investAmount)
                                self.raiseFundDatas.append(newRaiseFundDatas)
                            
                                DispatchQueue.main.async {
                                    self.tableview.reloadData()
                                }
                        }
                    }
                }
            }
        }
    }
}

extension RaiseFundInvestorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return raiseFundDatas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RaiseFundInvestorTableViewCell.self), for: indexPath) as! RaiseFundInvestorTableViewCell
        let tempStr = raiseFundDatas[indexPath.row].investor
        let subString = (tempStr! as NSString).substring(with: NSMakeRange(0,2))
        let subTemp = tempStr!.index(tempStr!.endIndex, offsetBy: -4)
        let SubString2 = String(tempStr!.suffix(from: subTemp))
        cell.iconimageView.image = UIImage(systemName: "lightbulb")
        cell.investorlabel.text = subString + "*****" + SubString2
        cell.investoramountlabel.text = raiseFundDatas[indexPath.row].investorAmount?.description ?? ""
    
            return cell
    }
}
