//
//  Profile.swift
//  00TestProj
//
//  Created by Александр Фофонов on 01.02.2023.
//

import Foundation

struct Profile: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case firstName = "first_name"
        case birthday = "bd"
    }
    
    typealias ID = String
    
    let id: ID
    let name: String?
    let firstName: String?
    let birthday: Date?
    
}

extension Profile: CustomDebugStringConvertible {
    
    var debugDescription: String {
        return "id: \(id), name: \(name), first name: \(firstName), birthday: \(birthday) )"
        }
    
}
