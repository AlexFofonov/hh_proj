//
//  MaterialTextFieldImp.swift
//  00TestProj
//
//  Created by Александр Фофонов on 23.03.2023.
//

import Foundation
import UIKit

class MaterialTextFieldImp: UIView, MaterialTextField {
    
    private enum Constants {
        enum Offset {
            static let horizontalPlaceholderLabel: CGFloat = 16
        }
        
        static let cornerRadius: CGFloat = 6
        static let borderWidth: CGFloat = 1
        
        static let placeholderLableText: String = "Номер телефона"
        
        static let defaultAnimationDuration: Double = 0.25
    }
    
    enum State {
        case `default`
        case active
        case error(_ message: LocalizedError)
    }
    
    var setFieldChanged: ((_ data: MaterialTextFieldOutputData) -> Void)?
    
    init() {
        super.init(frame: .zero)
        
        addSubview(textField)
        addSubview(placeholderLabel)
        addSubview(errorLable)
        
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        textField.frame = textFieldFrame(state: state)
        placeholderLabel.frame = placeholderLabelFrame(state: state)
        errorLable.frame = errorLabelFrame(state: state)
    }

    private func textFieldFrame(state: State) -> CGRect {
        .init(
            origin: .zero,
            size: .init(width: bounds.width, height: bounds.height)
        )
    }

    private func placeholderLabelFrame(state: State) -> CGRect {
        switch state {
        case .`default`:
            guard !textFieldText.isEmpty else {
                return placeholderLabelFrame(withOffset: false)
            }
            
            return placeholderLabelFrame(withOffset: true)
        default:
            return placeholderLabelFrame(withOffset: true)
        }
    }
    
    private func placeholderLabelFrame(withOffset: Bool) -> CGRect {
        switch withOffset {
        case true:
            return .init(
                x: Constants.Offset.horizontalPlaceholderLabel,
                y: -(bounds.height / 4),
                width: bounds.width,
                height: bounds.height
            )
        case false:
            return .init(
                x: Constants.Offset.horizontalPlaceholderLabel,
                y: 0,
                width: bounds.width,
                height: bounds.height
            )
        }
    }

    private func errorLabelFrame(state: State) -> CGRect {
        let size = errorLable.sizeThatFits(.init(width: bounds.width, height: 0))
        
        return .init(
            x: 0,
            y: bounds.height,
            width: bounds.width,
            height: size.height
        )
    }

    private(set) var state: State = .default
    
    private var textFieldText: String = ""
    
    func updateState(error: LocalizedError?) {
        guard let error = error else {
            update(state: .default, animated: true)
            return
        }
        
        update(state: .error(error), animated: true)
    }
    
    private func update(state: State, animated: Bool) {
        UIView.animate(withDuration: animated ? Constants.defaultAnimationDuration : 0) {
            self.update(state: state)
            self.layoutIfNeeded()
            self.superview?.layoutIfNeeded()
        }
    }

    private func update(state: State) {
        self.state = state

        switch state {
        case .`default`:
            textField.layer.backgroundColor = UIColor(named: "Colors/InactiveTextField")?.cgColor
            textField.layer.borderColor = UIColor(named: "Colors/InactiveTextField")?.cgColor
            
            placeholderLabel.alpha = 1
            
            if textFieldText.isEmpty {
                placeholderLabel.font = placeholderLabel.font.withSize(14)
            } else {
                placeholderLabel.font = placeholderLabel.font.withSize(12)
            }
            
            errorLable.text = nil
            errorLable.alpha = 0
        case .active:
            textField.layer.backgroundColor = UIColor(named: "Colors/ActiveTextField")?.cgColor
            textField.layer.borderColor = UIColor(named: "Colors/ActiveButton")?.cgColor
            
            placeholderLabel.alpha = 1
            placeholderLabel.font = placeholderLabel.font.withSize(12)
            
            errorLable.text = nil
            errorLable.alpha = 0
        case .error(let message):
            textField.layer.backgroundColor = UIColor(named: "Colors/ActiveTextField")?.cgColor
            textField.layer.borderColor = UIColor(named: "Colors/ErrorTextField")?.cgColor
            
            placeholderLabel.font = placeholderLabel.font.withSize(12)

            errorLable.text = message.errorDescription
            errorLable.alpha = 1
        }

        setNeedsLayout()
    }

    lazy var textField: MaterialTextFieldWithPadding = {
        let textField = MaterialTextFieldWithPadding()
        
        textField.backgroundColor = UIColor(named: "Colors/InactiveTextField")
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.layer.borderWidth = Constants.borderWidth
        textField.layer.borderColor = UIColor(named: "Colors/InactiveTextField")?.cgColor
        textField.textColor = UIColor(named: "Colors/Black")
        textField.font = .systemFont(ofSize: 14, weight: .init(400))
        
        return textField
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor(named: "Colors/PlaceholderLabel")
        label.font = .systemFont(ofSize: 14, weight: .init(400))
        
        return label
    }()
    
    private lazy var errorLable: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.textColor = UIColor(named: "Colors/ErrorTextField")
        label.font = .systemFont(ofSize: 12, weight: .init(400))
        
        return label
    }()

}

// MARK: - Logic

extension MaterialTextFieldImp {
    
    func addTargets() {
        textField.addTarget(self, action: #selector(textFieldEditingDidBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldEditingDidEnd), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(textFieldEditingChanged(sender:)), for: .editingChanged)
    }
    
    @objc
    func textFieldEditingDidBegin() {
        placeholderLabel.alpha = textFieldText.isEmpty ? 0 : 1

        switch state {
        case .error(_):
            placeholderLabel.alpha = 1
        default:
            update(state: .active, animated: true)
        }
    }
    
    @objc
    func textFieldEditingDidEnd() {
        placeholderLabel.alpha = textFieldText.isEmpty ? 0 : 1

        switch state {
        case .error(_):
            placeholderLabel.alpha = 1
        default:
            update(state: .default, animated: true)
        }
    }
    
    @objc
    func textFieldEditingChanged(sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        
        textFieldText = text
        setFieldChanged?(
            MaterialTextFieldOutputData(
                text: text,
                error: nil
            )
         )
    }
    
    func updateLabelText(_ labelText: String) {
        placeholderLabel.text = labelText
    }
    
    func updateKeyboardType(_ keyboardType: UIKeyboardType) {
        textField.keyboardType = keyboardType
    }
    
}
