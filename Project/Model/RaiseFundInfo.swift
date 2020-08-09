//
//  RaiseFundInfo.swift
//  SpiritBond
//
//  Created by Fung Ying Hei on 24/7/2020.
//  Copyright © 2020 茂木匠. All rights reserved.
//

import Foundation

struct RaiseFundInfo: Codable {
    var title: String?
    var amount: Int?
    var rateReturn: Double?
    var stock: String?
    var index: String?
    var ideas: String?
    var image: Data?
    var imageURL: String?
    var storageName: String?
    var date: String
}
