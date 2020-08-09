//
//  RaiseFundTableViewCell.swift
//  SpiritBond
//
//  Created by Fung Ying Hei on 31/7/2020.
//  Copyright © 2020 茂木匠. All rights reserved.
//

import UIKit

class RaiseFundTableViewCell: UITableViewCell {
        @IBOutlet weak var raiseFundImageView: UIImageView!
        @IBOutlet weak var raiseFundTitleLabel: UILabel!
        @IBOutlet weak var raiseFundStockLabel: UILabel!
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }

    }
