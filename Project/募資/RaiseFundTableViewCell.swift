//
//  RaiseFundTableViewCell.swift
//  spiritbond
//
//  Created by lim jia le on 2020/9/24.
//

import UIKit

class RaiseFundTableViewCell: UITableViewCell {
    
    @IBOutlet weak var raisefundImageView: UIImageView!
    @IBOutlet weak var raisefundTitleLabel: UILabel!
    @IBOutlet weak var raisefundStockLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
