//
//  FundRaiseInfo.swift
//  SpiritBond
//
//  Created by Fung Ying Hei on 23/7/2020.
//  Copyright © 2020 茂木匠. All rights reserved.
//
import Foundation

struct FundraiseInfo: Codable {

    var title: String!
    var money: Int!
    var image: Data?
    var imageURL: String?
    var date: String!
    var idea: String!
    var rateReturn: Int!
    var index: String!
    var stock: String!
    
}
