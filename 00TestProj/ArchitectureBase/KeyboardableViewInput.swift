//
//  KeyboardableViewInput.swift
//  00TestProj
//
//  Created by Александр Фофонов on 11.04.2023.
//

import UIKit

public protocol KeyboardableViewInput: AnyObject {
    
    func connectKeyboard()
    func disconnectKeyboard()
    
}

public protocol KeyboardableView: KeyboardableViewInput {
    
    var keyboardToken: Any? { get set }
    
    func apply(keyboardHeight: CGFloat)
    
}

extension KeyboardableView where Self: UIView {
    
    func connectKeyboard() {
        keyboardToken = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main) { [weak self] notification in
                self?.update(with: notification)
            }
    }
    
    func disconnectKeyboard() {
        keyboardToken = nil
    }
    
    private func update(with notification: Notification) {
        let keyboardRect: CGRect? = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        
        guard let keyboardHeight = keyboardRect?.height else {
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.apply(keyboardHeight: keyboardHeight)
        }
    }
    
}
