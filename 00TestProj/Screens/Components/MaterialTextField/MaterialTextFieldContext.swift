//
//  MaterialTextFieldContext.swift
//  00TestProj
//
//  Created by Александр Фофонов on 20.04.2023.
//

import Foundation
import UIKit

struct MaterialTextFieldContext {
    
    let labelText: String
    let keyboardType: UIKeyboardType
    let setFieldChanged: ((_ data: MaterialTextFieldOutputData) -> LocalizedError?)
    
}
