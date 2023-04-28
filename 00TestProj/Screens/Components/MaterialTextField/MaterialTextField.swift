//
//  MaterialTextField.swift
//  00TestProj
//
//  Created by Александр Фофонов on 20.04.2023.
//

import Foundation
import UIKit

protocol MaterialTextField: UIView {
    
    var setFieldChanged: ((_ data: MaterialTextFieldOutputData) -> Void)? { get set }
    func updateLabelText(_ labelText: String)
    func updateKeyboardType(_ keyboardType: UIKeyboardType)
    func updateState(error: LocalizedError?)
    
}
