//
//  stock.swift
//  spiritbond
//
//  Created by lim jia le on 2020/9/24.
//

import Foundation
struct stock: Codable{
    
    var date: String
    var open: Double
    var close: Double
    var high: Double
    var low: Double
    var volume: Double
    var change: Double
}
