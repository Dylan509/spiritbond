//
//  PortfolioCell.swift
//  spiritbond
//
//  Created by lim jia le on 2020/10/19.
//

import UIKit

class PortfolioCell: UITableViewCell {
    
    @IBOutlet var valuelabel: UILabel!
    @IBOutlet var symbollabel: UILabel!
    @IBOutlet var shareslabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
