//
//  Warehouse.swift
//  Wholesale Company Manager
//
//  Created by panandafog on 12.04.2021.
//

enum Warehouse {
    case small
    case big
    
    func path() -> String {
        switch self {
        case .small:
            return "/warehouse1"
        case .big:
            return "/warehouse2"
        }
    }
}
