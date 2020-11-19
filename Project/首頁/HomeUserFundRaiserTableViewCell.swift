//
//  HomeUserFundRaiserTableViewCell.swift
//  spiritbond
//
//  Created by Fung Ying Hei on 29/9/2020.
//

import UIKit

class HomeUserFundRaiserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconAmountImageView: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
