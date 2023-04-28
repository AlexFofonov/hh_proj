//
//  Assembly+Formatters.swift
//  00TestProj
//
//  Created by Александр Фофонов on 27.01.2023.
//

import Foundation

extension Assembly {
    
    enum DateFormat: String {
        case yyyyMMdd = "yyyy MM dd"
        case kebab_yyyyMMdd = "yyyy-MM-dd"
        case HHmmss = "HH:mm:ss"
        case FULL = "yyyy-MM-dd HH:mm:ss"
    }
    
    func dateFormatter(format: DateFormat) -> DateFormatterProtocol {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter
    }
    
}
