//
//  VerificationViewImp.swift
//  00TestProj
//
//  Created by Александр Фофонов on 03.04.2023.
//

import UIKit

class VerificationViewImp: UIView, VerificationView {
    
    private enum Constants {
        enum Margin {
            static let horizontalMain: CGFloat = 30
            static let horizontalTextField: CGFloat = 110
            static let horizontalDotsStack: CGFloat = 120
            static let top: CGFloat = 158
        }
    }
    
    var onRepeatSendCode: (() -> Void)?
    var throwCode: ((String?) -> Void)?
    private var codeLength: Int = 0
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor(named: "Colors/Background")
        
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(dotsStack)
        addSubview(textFieldsStack)
        addSubview(requestLabel)
        addSubview(sendCodeButton)
        
        NSLayoutConstraint.activate(
            [
                titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.Margin.top),
                titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.Margin.horizontalMain),
                titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.Margin.horizontalMain),
                
                descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
                descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.Margin.horizontalMain),
                descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.Margin.horizontalMain),
                
                dotsStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
                dotsStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.Margin.horizontalDotsStack),
                dotsStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.Margin.horizontalDotsStack),
                dotsStack.heightAnchor.constraint(equalToConstant: 54),
                
                textFieldsStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
                textFieldsStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.Margin.horizontalTextField),
                textFieldsStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.Margin.horizontalTextField),
                
                requestLabel.topAnchor.constraint(equalTo: textFieldsStack.bottomAnchor, constant: 30),
                requestLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.Margin.horizontalMain),
                requestLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.Margin.horizontalMain),

                sendCodeButton.topAnchor.constraint(equalTo: requestLabel.bottomAnchor, constant: 30),
                sendCodeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.Margin.horizontalMain),
                sendCodeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.Margin.horizontalMain),
                sendCodeButton.heightAnchor.constraint(equalToConstant: 20),
            ]
        )
        
        addTargets()
        updateCodeField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 26, weight: .init(800))
        label.textColor = UIColor(named: "Colors/Black")
        label.numberOfLines = 0
        label.text = "ВВЕДИТЕ КОД"
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .init(400))
        label.textColor = UIColor(named: "Colors/Black")
        label.numberOfLines = 0
        label.text = "Мы отправили код на номер\n+7 "
        
        return label
    }()
    
    private var dotsStackSubviews: [UIView] = []
    
    private lazy var dotsStack: UIStackView = {
        createDots()
        
        let stackView = UIStackView(arrangedSubviews: dotsStackSubviews)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 30
        
        return stackView
    }()
    
    private func createDots() {
        for _ in 0...3 {
            let imageView = UIImageView()
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = UIImage(named: "Verification/Dot")
            imageView.contentMode = .center
            
            dotsStackSubviews.append(imageView)
        }
    }
    
    @objc
    func updateCodeField() {
        guard let textFields: [UITextField] = textFieldsStackSubviews as? [UITextField] else {
            return
        }
        let dots = dotsStackSubviews
        
        guard codeLength < 4 else {
            throwCode?(packCode(textFields: textFields))
            
            codeLength = 0
            clearTextFieldsStack(textFields)
            fillDotsStack(dots)
            updateCodeField()
            return
        }
        
        updateTextFieldsStack(textFields)
        updateDotsStack(dots)
        
        codeLength += 1
    }
    
    private var textFieldsStackSubviews: [UIView] = []
    
    private lazy var textFieldsStack: UIStackView = {
        createTextFields()
        
        let stackView = UIStackView(arrangedSubviews: textFieldsStackSubviews)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        
        return stackView
    }()
    
    private func createTextFields() {
        for _ in 0...3 {
            let textField = UITextField()
            
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.textColor = UIColor(named: "Colors/Black")
            textField.font = .systemFont(ofSize: 40, weight: .init(400))
            textField.keyboardType = .asciiCapableNumberPad
            textField.defaultTextAttributes.updateValue(12, forKey: .kern)
            textField.textAlignment = .center
            textField.tintColor = UIColor.clear
            textField.isUserInteractionEnabled = false
            textField.delegate = self
            
            textFieldsStackSubviews.append(textField)
        }
    }
    
    private lazy var requestLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .init(400))
        label.textColor = UIColor(named: "Colors/Black")
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var sendCodeButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(named: "Colors/ActiveButton"), for: .normal)
        button.alpha = 0
        button.setTitle("Получить код повторно", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .init(500))
        button.isEnabled = false
        
        return button
    }()
    
}

extension VerificationViewImp: UITextFieldDelegate {
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let textFieldTextCount = textField.text?.count ?? 0
        
        let decimalDigitsSet = NSCharacterSet.decimalDigits
        let separatedCharacters = string.components(separatedBy: decimalDigitsSet)
        let decimalDigitsSetFiltered = separatedCharacters.joined(separator: "")
        
        return textFieldTextCount + string.count - range.length <= 1 && string != decimalDigitsSetFiltered
    }
    
}

// MARK: - Implementation VerificationView functions

extension VerificationViewImp {
    
    func updatePhone(phone: String) {
        guard descriptionLabel.text != nil else {
            return
        }
        
        descriptionLabel.text? += phone
    }
    
    func updateTimer(with timeLeft: Int) {
        requestLabel.text = "Получить новый код можно через \(formatTime(time: timeLeft))"
    }
    
    private func formatTime(time: Int) -> String {
        let minutes = floor(Double(time / 60))
        let seconds = Double(time) - minutes * 60
        var timeLeftString = ""
        
        if modf(minutes / 10).0 == 0 {
            timeLeftString = "0\(Int(minutes)):"
        } else {
            timeLeftString = "\(Int(minutes)):"
        }
        
        if modf(seconds / 10).0 == 0 {
            timeLeftString += "0\(Int(seconds))"
        } else {
            timeLeftString += "\(Int(seconds))"
        }
        
        return timeLeftString
    }
    
    func sendCodeIsActive(_ isActive: Bool) {
        sendCodeButton.isEnabled = isActive
        isActive ? (sendCodeButton.alpha = 1) : (sendCodeButton.alpha = 0)
    }
    
}

// MARK: - Targets

extension VerificationViewImp {
    
    func addTargets() {
        sendCodeButton.addTarget(self, action: #selector(onRepeatSendCodeHandler), for: .touchUpInside)
        
        guard let textFields: [UITextField] = textFieldsStackSubviews as? [UITextField] else {
            return
        }
        
        for item in textFields {
            item.addTarget(self, action: #selector(updateCodeField), for: .editingChanged)
        }
    }
    
    @objc
    func onRepeatSendCodeHandler() {
        onRepeatSendCode?()
    }
    
}

// MARK: - Update codeField

extension VerificationViewImp {
    
    func updateTextFieldsStack(_ elements: [UITextField]) {
        let empty = elements[codeLength]
        empty.isUserInteractionEnabled = true
        empty.becomeFirstResponder()
        
        if codeLength > 0 {
            elements[codeLength-1].isUserInteractionEnabled = false
        }
    }
    
    func updateDotsStack(_ elements: [UIView]) {
        guard codeLength > 0 else {
            return
        }
        
        elements[codeLength-1].alpha = 0
    }
    
    func clearTextFieldsStack(_ elements: [UITextField]) {
        for item in elements {
            item.text = ""
            item.isUserInteractionEnabled = false
        }
    }
    
    func fillDotsStack(_ elements: [UIView]) {
        for item in elements {
            item.alpha = 1
        }
    }
    
    private func packCode(textFields: [UITextField]) -> String {
        var code: String = ""
        
        for item in textFields {
            code += item.text ?? ""
        }
        
        return code
    }
    
}
