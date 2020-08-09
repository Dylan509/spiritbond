//
//  UpdateLabel.swift
//  Project
//
//  Created by jiale on 7/7/2020.
//  Copyright © 2020 茂木匠. All rights reserved.
//

import UIKit

class UpdateLabel: UILabel {

    var provider: Provider?
    var date: Date?

    private var dateFormatter = DateFormatter()
    private var relativeDateFormatter = RelativeDateTimeFormatter()

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

}

extension UpdateLabel {
    
    func update() {
        if let string = agoText {
            text = string
        }
    }

}

private extension UpdateLabel {

    var agoText: String? {
        guard let date = date else { return nil }

        var relative = relativeDateFormatter.localizedString(for: date, relativeTo: Date())

        if relative.contains("in ") {
            relative = "剛剛"
        }

        let string = "最後更新 \(dateFormatter.string(from: Date()))\(Theme.separator)\(provider?.rawValue ?? "") · \(relative)"

        return string
    }

    func setup() {
        font = .preferredFont(forTextStyle: .caption1)
        textAlignment = .center
        textColor = .secondaryLabel

        dateFormatter.dateFormat = "MMM d h:mm a"
    }

}

