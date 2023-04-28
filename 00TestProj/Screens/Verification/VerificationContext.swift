//
//  VerificationContext.swift
//  00TestProj
//
//  Created by Александр Фофонов on 14.04.2023.
//

import Foundation

struct VerificationContext {
    
    let phone: String
    let timeLimit: Int
    let finishFlow: ((_ operationToken: String) -> Void)
    
}
