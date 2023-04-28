//
//  Assembly+BootstrapDataProvider.swift
//  00TestProj
//
//  Created by Александр Фофонов on 26.02.2023.
//

import Foundation

extension Assembly {
    
    var bootstrapDataProvider: BootstrapDataProvider {
        .init(apiClient: apiClient)
    }
    
}
