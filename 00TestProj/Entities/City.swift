//
//  City.swift
//  00TestProj
//
//  Created by Александр Фофонов on 26.02.2023.
//

import Foundation

struct City: Codable {
    
    typealias ID = String
    
    let id: ID
    let name: String?
    
}

extension City: CustomDebugStringConvertible {
    
    var debugDescription: String {
        return "id: \(id), city_name: \(name))"
        }
    
}
