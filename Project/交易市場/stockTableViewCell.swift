//
//  stockTableViewCell.swift
//  spiritbond
//
//  Created by lim jia le on 2020/9/27.
//

import UIKit

class stockTableViewCell: UITableViewCell {
    
    @IBOutlet var StockNameLabel: UILabel!
    @IBOutlet var StockSymbolLabel: UILabel!
    @IBOutlet var StockPercentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
