//
//  RaiseFundInvestorTableViewCell.swift
//  spiritbond
//
//  Created by lim jia le on 2020/9/24.
//

import UIKit

class RaiseFundInvestorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconimageView: UIImageView!
    @IBOutlet weak var investorlabel: UILabel!
    @IBOutlet weak var investoramountlabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
