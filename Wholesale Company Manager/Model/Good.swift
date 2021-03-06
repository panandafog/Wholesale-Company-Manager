//
//  Good.swift
//  Wholesale Company Manager
//
//  Created by panandafog on 10.04.2021.
//

struct Good: Codable {
    var id: Int?
    var name = "<name>"
    var priority: Int? = 1

    // for popularity stats
    var count: Int?
}
