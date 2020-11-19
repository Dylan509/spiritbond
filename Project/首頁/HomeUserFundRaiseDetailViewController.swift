//
//  HomeUserFundRaiseDetailViewController.swift
//  spiritbond
//
//  Created by Fung Ying Hei on 10/10/2020.
//

import UIKit
import Firebase

class HomeUserFundRaiseDetailViewController: UIViewController {

    var detailData: UserInfo?
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.allowsSelection = false

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fundRaiseShow" {
            if let data = detailData {
                let destinationVC = segue.destination as! HomeUserFundRaiseShowRecordViewController
                destinationVC.userInfo = data
            }
        }
        
    }

}

extension HomeUserFundRaiseDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeUserFundRaiseDetailTableViewCell.self), for: indexPath) as! HomeUserFundRaiseDetailTableViewCell
            cell.icon.image = UIImage(systemName: "flag")
            cell.typeLabel.text = "項目名稱："
            cell.dataLabel.text = detailData?.title ?? ""
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeUserFundRaiseDetailTableViewCell.self), for: indexPath) as! HomeUserFundRaiseDetailTableViewCell
            cell.icon.image = UIImage(systemName: "chart.bar")
            cell.typeLabel.text = "股票："
            cell.dataLabel.text = detailData?.stock ?? ""
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeUserFundRaiseDetailTableViewCell.self), for: indexPath) as! HomeUserFundRaiseDetailTableViewCell
            cell.icon.image = UIImage(systemName: "arrow.up.arrow.down.square")
            cell.typeLabel.text = "預估報酬率："
            cell.dataLabel.text = detailData?.rateReturn?.description ?? ""
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeUserFundRaiseDetailTableViewCell.self), for: indexPath) as! HomeUserFundRaiseDetailTableViewCell
            cell.icon.image = UIImage(systemName: "calendar.badge.plus")
            cell.typeLabel.text = "募資開始時間："
            cell.dataLabel.text = detailData?.txtDate ?? ""
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeUserFundRaiseDetailTableViewCell.self), for: indexPath) as! HomeUserFundRaiseDetailTableViewCell
            cell.icon.image = UIImage(systemName: "calendar.badge.minus")
            cell.typeLabel.text = "募資截止時間："
            cell.dataLabel.text = detailData?.deadlineDate ?? ""
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeUserFundRaiseDetailTableViewCell.self), for: indexPath) as! HomeUserFundRaiseDetailTableViewCell
            cell.icon.image = UIImage(systemName: "dollarsign.circle")
            cell.typeLabel.text = "投資金額："
            cell.dataLabel.text = detailData?.amount?.description ?? ""
            return cell
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
    }
}
