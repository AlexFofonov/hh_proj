//
//  MaterialTextFieldVC.swift
//  00TestProj
//
//  Created by Александр Фофонов on 20.04.2023.
//

import Foundation
import UIKit

final class MaterialTextFieldVC<View: MaterialTextField>: BaseVC<View> {
    
    var setFieldChanged: ((_ data: MaterialTextFieldOutputData) -> LocalizedError?)?
    
    init(labelText: String, keyboardType: UIKeyboardType) {
        super.init(nibName: nil, bundle: nil)
        
        rootView.updateLabelText(labelText)
        rootView.updateKeyboardType(keyboardType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.setFieldChanged = { [weak self] data in
            guard let self = self else {
                return
            }
            
            let error = self.setFieldChanged?(data)
            self.rootView.updateState(error: error)
        }
    }
    
}
