//
//  Assembly+ApiClient.swift
//  00TestProj
//
//  Created by Александр Фофонов on 03.02.2023.
//

import Foundation

extension Assembly {
    
    var apiClient: ApiClient {
        .init(decoder: decoder)
    }
    
}
