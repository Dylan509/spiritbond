//
//  HomeUserNoticeTableViewCell.swift
//  spiritbond
//
//  Created by Fung Ying Hei on 1/11/2020.
//

import UIKit

class HomeUserNoticeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconimageView: UIImageView!
    @IBOutlet weak var noticelabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        noticelabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        noticelabel.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
