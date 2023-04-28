//
//  Assembly+DataStorage.swift
//  00TestProj
//
//  Created by Александр Фофонов on 01.02.2023.
//

import Foundation

extension Assembly {

    var encoder: JSONEncoder {
        JSONEncoder()
    }
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .formatted(dateFormatter(format: .kebab_yyyyMMdd))
        
        return decoder
    }
    
}
