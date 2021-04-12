//
//  Sale.swift
//  Wholesale Company Manager
//
//  Created by panandafog on 12.04.2021.
//

import Foundation

struct Sale: Codable {
    let id: Int?
    var createDate: String = {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        return formatter.string(from: today)
    }()
    var good: Good
    var goodCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case createDate = "create_date"
        case good
        case goodCount = "good_count"
    }
}
