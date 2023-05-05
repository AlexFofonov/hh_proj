//
//  Assembly+VC.swift
//  00TestProj
//
//  Created by Александр Фофонов on 23.04.2023.
//

import UIKit

extension Assembly {
    
    func authVC() -> AuthVC<AuthViewImp> {
        .init(authProvider: AuthProviderImp())
    }
    
    func verificationVC(
        phone: String,
        timeLimit: Int
    ) -> VerificationVC<VerificationViewImp> {
        .init(verificationProvider: VerificationProviderImp(), phone: phone, timeLimit: timeLimit)
    }
    
    func materialTextFieldVC(
        labelText: String,
        keyboardType: UIKeyboardType
    ) -> MaterialTextFieldVC<MaterialTextFieldImp> {
        .init(labelText: labelText, keyboardType: keyboardType)
    }
    
    func catalogVC() -> CatalogVC<CatalogViewImp> {
        .init(catalogProvider: CatalogProviderImp(decoder: decoder))
    }
    
}
