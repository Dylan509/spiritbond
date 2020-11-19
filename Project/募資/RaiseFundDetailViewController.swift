//
//  RaiseFundDetailViewController.swift
//  spiritbond
//
//  Created by lim jia le on 2020/9/24.
//

import UIKit
import Firebase

class RaiseFundDetailViewController: UIViewController {
    
    var detailData: RaiseFundInfo?
    let defaultURL = "https://firebasestorage.googleapis.com/v0/b/spiritbond-8d54d.appspot.com/o/photo%2Flee.jpg?alt=media&token=461759c5-5a2f-425e-9384-9bd0d2d443c9"
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var headerview: RaiseFundDetailHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        if let data = detailData, let image = data.image {
            headerview.headerimageView.image = UIImage(data: image)
            headerview.namelabel.text = data.title
        }
        
        // Do any additional setup after loading the view.
    }
}

extension RaiseFundDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RaiseFundDetailTableViewCell.self), for: indexPath) as! RaiseFundDetailTableViewCell
            cell.iconimageView.image = UIImage(systemName: "flag")
            cell.typelabel.text = "標題："
            cell.infolabel.text = detailData?.title ?? ""
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RaiseFundDetailTableViewCell.self), for: indexPath) as! RaiseFundDetailTableViewCell
            cell.iconimageView.image = UIImage(systemName: "dollarsign.circle")
            cell.typelabel.text = "目標募資金額："
            cell.infolabel.text = detailData?.amount?.description ?? ""
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RaiseFundDetailTableViewCell.self), for: indexPath) as! RaiseFundDetailTableViewCell
            cell.iconimageView.image = UIImage(systemName: "arrow.up.arrow.down.square")
            cell.typelabel.text = "預計報酬率："
            cell.infolabel.text = detailData?.rateReturn?.description ?? ""
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RaiseFundDetailTableViewCell.self), for: indexPath) as! RaiseFundDetailTableViewCell
            cell.iconimageView.image = UIImage(systemName: "person")
            cell.typelabel.text = "提案人等級："
            cell.infolabel.text = ""
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RaiseFundDetailTableViewCell.self), for: indexPath) as! RaiseFundDetailTableViewCell
            cell.iconimageView.image = UIImage(systemName: "chart.bar")
            cell.typelabel.text = "股票："
            cell.infolabel.text = detailData?.stock ?? ""
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RaiseFundDetailTableViewCell.self), for: indexPath) as! RaiseFundDetailTableViewCell
            cell.iconimageView.image = UIImage(systemName: "waveform.path.ecg")
            cell.typelabel.text = "投資策略："
            cell.infolabel.text = detailData?.index ?? ""
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RaiseFundDetailTableViewCell.self), for: indexPath) as! RaiseFundDetailTableViewCell
            cell.iconimageView.image = UIImage(systemName: "lightbulb")
            cell.typelabel.text = "想法："
            cell.infolabel.text = detailData?.ideas ?? ""
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RaiseFundDetailTableViewCell.self), for: indexPath) as! RaiseFundDetailTableViewCell
            cell.iconimageView.image = UIImage(systemName: "chart.bar.xaxis")
            cell.typelabel.text = "投資類型："
            cell.infolabel.text = detailData?.typeOfUser ?? ""
            return cell
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RaiseFundDetailTableViewCell.self), for: indexPath) as! RaiseFundDetailTableViewCell
            cell.iconimageView.image = UIImage(systemName: "calendar.badge.plus")
            cell.typelabel.text = "募資結束日期："
            cell.infolabel.text = detailData?.txtDate ?? ""
            return cell
        case 9:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RaiseFundDetailTableViewCell.self), for: indexPath) as! RaiseFundDetailTableViewCell
            cell.iconimageView.image = UIImage(systemName: "calendar.badge.minus")
            cell.typelabel.text = "募資結算日期："
            cell.infolabel.text = detailData?.deadlineDate ?? ""
            return cell
        case 10:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RaiseFundDetailTableViewCell.self), for: indexPath) as! RaiseFundDetailTableViewCell
            cell.iconimageView.image = UIImage(systemName: "dollarsign.square")
            cell.typelabel.text = "目前募資金額："
            cell.infolabel.text = detailData?.raisingAmount?.description ?? ""
            return cell
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "investDetail" {
            if let data = detailData {
                let destinationVC = segue.destination as! RaiseFundInvestViewController
                destinationVC.raiseFundInfo = data
            }
        }
        
        if segue.identifier == "investorDetail" {
            if let dataRecord = detailData {
                let destinationVC = segue.destination as! RaiseFundInvestorViewController
                destinationVC.raiseFundInfo = dataRecord
            }
        }
        

    }
}
