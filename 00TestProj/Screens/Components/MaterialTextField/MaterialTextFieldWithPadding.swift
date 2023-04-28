//
//  TextFieldWithPadding.swift
//  00TestProj
//
//  Created by Александр Фофонов on 24.03.2023.
//

import Foundation
import UIKit

class MaterialTextFieldWithPadding: UITextField {
    
    private let textPadding = UIEdgeInsets(
        top: 14,
        left: 16,
        bottom: 0,
        right: 0
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
