//
//  RaiseFundDetailViewController.swift
//  SpiritBond
//
//  Created by Fung Ying Hei on 31/7/2020.
//  Copyright © 2020 茂木匠. All rights reserved.
//

import UIKit

class RaiseFundDetailViewController: UIViewController {
        
        var detailData: RaiseFundInfo?

        
        @IBOutlet weak var tableView: UITableView!
        @IBOutlet weak var headerView: RaiseFundDetailHeaderView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.backgroundColor = UIColor(red: 229 / 255, green: 216 / 255, blue: 191 / 255, alpha: 1)

            
            if let data = detailData, let image = data.image {
                headerView.headerImageView.image = UIImage(data: image)
                headerView.nameLabel.text = data.title
            }
            
            // Do any additional setup after loading the view.
        }
        
    }

    extension RaiseFundDetailViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 7
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RaiseFundDetailTableViewCell.self), for: indexPath) as! RaiseFundDetailTableViewCell
                cell.iconImageView.image = UIImage(systemName: "title")
                cell.infoLabel.text = detailData?.title ?? ""
                cell.backgroundColor = UIColor(red: 229 / 255, green: 216 / 255, blue: 191 / 255, alpha: 1)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RaiseFundDetailTableViewCell.self), for: indexPath) as! RaiseFundDetailTableViewCell
                cell.iconImageView.image = UIImage(systemName: "amount")
                cell.infoLabel.text = detailData?.amount?.description ?? ""
                cell.backgroundColor = UIColor(red: 229 / 255, green: 216 / 255, blue: 191 / 255, alpha: 1)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RaiseFundDetailTableViewCell.self), for: indexPath) as! RaiseFundDetailTableViewCell
                cell.iconImageView.image = UIImage(systemName: "rate return")
                cell.infoLabel.text = detailData?.rateReturn?.description ?? ""
                cell.backgroundColor = UIColor(red: 229 / 255, green: 216 / 255, blue: 191 / 255, alpha: 1)
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RaiseFundDetailTableViewCell.self), for: indexPath) as! RaiseFundDetailTableViewCell
                cell.iconImageView.image = UIImage(systemName: "stock")
                cell.infoLabel.text = detailData?.stock ?? ""
                cell.backgroundColor = UIColor(red: 229 / 255, green: 216 / 255, blue: 191 / 255, alpha: 1)
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RaiseFundDetailTableViewCell.self), for: indexPath) as! RaiseFundDetailTableViewCell
                cell.iconImageView.image = UIImage(systemName: "index")
                cell.infoLabel.text = detailData?.index ?? ""
                cell.backgroundColor = UIColor(red: 229 / 255, green: 216 / 255, blue: 191 / 255, alpha: 1)
                return cell
            case 5:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RaiseFundDetailTableViewCell.self), for: indexPath) as! RaiseFundDetailTableViewCell
                cell.iconImageView.image = UIImage(systemName: "ideas")
                cell.infoLabel.text = detailData?.ideas ?? ""
                cell.backgroundColor = UIColor(red: 229 / 255, green: 216 / 255, blue: 191 / 255, alpha: 1)
                return cell
            default:
                fatalError("Failed to instantiate the table view cell for detail view controller")
            }
        }
        
    }


