//
//  RaiseFundDetailTableViewCell.swift
//  spiritbond
//
//  Created by lim jia le on 2020/9/24.
//

import UIKit

class RaiseFundDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconimageView: UIImageView!
    @IBOutlet weak var typelabel: UILabel!
    @IBOutlet weak var infolabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
