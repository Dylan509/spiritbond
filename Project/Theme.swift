//
//  Theme.swift
//  Project
//
//  Created by jiale on 7/7/2020.
//  Copyright © 2020 茂木匠. All rights reserved.
//

import UIKit

struct Theme {

    static let attributes = [ NSAttributedString.Key.foregroundColor: color ]

    static var closeButton: UIBarButtonItem {
        let image = UIImage(systemName: "xmark")
        let button = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        button.tintColor = Theme.color

        return button
    }

    static let color = UIColor.systemTeal

    static let separator = " · "

}
