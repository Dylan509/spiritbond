//
//  RaiseFundInfo.swift
//  spiritbond
//
//  Created by lim jia le on 2020/9/24.
//

import Foundation
struct RaiseFundInfo: Codable {
    var creator: String?
    var title: String?
    var amount: Int?
    var rateReturn: Double?
    var stock: String?
    var index: String?
    var ideas: String?
    var image: Data?
    var typeOfUser: String?
    var txtDate: String?
    var imageURL: String?
    var storageName: String?
    var date: String
    var raisingAmount: Int?
    var temp: Int?
    var deadlineDate: String?
}

struct TypeRaiseFund {
    let type = ["短線（1周內）", "中線（1個月內）", "中長線（1個月以上）"]
}
