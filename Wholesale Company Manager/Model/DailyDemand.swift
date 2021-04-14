//
//  DailyDemand.swift
//  Wholesale Company Manager
//
//  Created by panandafog on 14.04.2021.
//

struct DailyDemand: Codable {
    var day: Int
    var goodCount: Double
    
    enum CodingKeys: String, CodingKey {
        case day
        case goodCount = "good_count"
    }
}
