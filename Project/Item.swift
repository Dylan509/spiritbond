//
//  Item.swift
//  Project
//
//  Created by jiale on 7/7/2020.
//  Copyright © 2020 茂木匠. All rights reserved.
//

import Foundation

struct Item: Codable {

    var symbol: String?
    var quote: MyQuote?

}

extension Item: Equatable {

    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.symbol == rhs.symbol
    }

}
