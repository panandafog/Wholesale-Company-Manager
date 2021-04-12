//
//  Rack.swift
//  Wholesale Company Manager
//
//  Created by panandafog on 12.04.2021.
//

struct Rack: Codable {
    let id: Int?
    var good: Good
    var goodCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case good
        case goodCount = "good_count"
    }
}
