//
//  TextUpperLeftLabel.swift
//  spiritbond
//
//  Created by Fung Ying Hei on 5/11/2020.
//

import UIKit

class TextUpperLeftLabel: UILabel {

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        textRect.origin.y = bounds.origin.y
        return textRect
    }
     
    override func drawText(in rect: CGRect) {
        let actualRect = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: actualRect)
    }

}
