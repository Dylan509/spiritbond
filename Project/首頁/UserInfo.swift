//
//  UserInfo.swift
//  spiritbond
//
//  Created by Fung Ying Hei on 29/9/2020.
//

import Foundation

struct UserInfo: Codable {
    var title: String?
    var amount: Int?
    var lastname: String?
    var balance: Int?
    
    var stock: String?
    var rateReturn: Double?
    var txtDate: String?
    var deadlineDate: String?
    var date: String
    var userId: String?
    var imageURL: String?
    var storageName: String?
    var image: Data?
    var report: String?
    var dateUpload: String?

}
