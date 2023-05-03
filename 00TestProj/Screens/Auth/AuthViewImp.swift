//
//  AuthViewMock.swift
//  00TestProj
//
//  Created by Александр Фофонов on 01.04.2023.
//

import UIKit

class AuthViewImp: UIView, AuthView, KeyboardableView {

    private enum Constants {
        enum Margin {
            static let horizontalMainStackView: CGFloat = 30
            static let horizontalFooterStackView: CGFloat = 78
            static let bottom: CGFloat = 50
        }
        
        static let buttonHeight: CGFloat = 42
        static let authTextFieldContainerViewHeight: CGFloat = 56
        
        static let buttonСornerRadius: CGFloat = 8
        static let labelСornerRadius: CGFloat = 6
        
        static let defaultAnimationDuration: Double = 0.25
    }
    
    var onVerify: (() -> Void)?
    
    var keyboardToken: Any?
    
    var indicator: UIActivityIndicatorView?
        
    init() {
        super.init(frame: .zero)
        
        indicator = loadingIndicator
        
        backgroundColor = UIColor(named: "Colors/Background")
        
        addSubview(logoImageView)
        addSubview(mainStackView)
        addSubview(loadingIndicator)
        addSubview(footerStackView)
        
        let mainStackViewTopConstraint = mainStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor)
        self.mainStackViewTopConstraint = mainStackViewTopConstraint
        
        let logoImageViewTopConstraint = logoImageView.topAnchor.constraint(equalTo: self.topAnchor)
        self.logoImageViewTopConstraint = logoImageViewTopConstraint
        
        let footerStackViewBottomConstraint = footerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.Margin.bottom)
        self.footerStackViewBottomConstraint = footerStackViewBottomConstraint
        
        NSLayoutConstraint.activate(
            [
                logoImageViewTopConstraint,
                logoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),

                mainStackViewTopConstraint,
                mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.Margin.horizontalMainStackView),
                mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.Margin.horizontalMainStackView),
                
                phoneStackView.heightAnchor.constraint(equalToConstant: Constants.authTextFieldContainerViewHeight),
                phoneStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.Margin.horizontalMainStackView),
                phoneStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.Margin.horizontalMainStackView),
                
                codeNumberLabel.widthAnchor.constraint(equalToConstant: 45),
                
                loginButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
                
                loadingIndicator.topAnchor.constraint(equalTo: loginButton.topAnchor),
                loadingIndicator.bottomAnchor.constraint(equalTo: loginButton.bottomAnchor),
                loadingIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
                
                footerStackViewBottomConstraint,
                footerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.Margin.horizontalFooterStackView),
                footerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.Margin.horizontalFooterStackView),
            ]
        )

        addTargets()
        toDismissKeyboard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var mainStackViewTopConstraint: NSLayoutConstraint?
    private var logoImageViewTopConstraint: NSLayoutConstraint?
    private var footerStackViewBottomConstraint: NSLayoutConstraint?
    
    private var mainStackViewSubviews: [UIView] {
        [
            titleLabel,
            phoneStackView,
            loginButton
        ]
    }
    
    private var phoneStackViewSubviews: [UIView] {
        [
            codeNumberLabel,
            phoneContainer
        ]
    }
    
    private var footerStackViewSubviews: [UIView] {
        [
            appleCircleLogoImageView,
            vkCircleLogoImageView,
            okCircleLogoImageView,
            facebookCircleLogoImageView
        ]
    }

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Auth/BackgroundLogo")
        
        return imageView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: mainStackViewSubviews)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 30
        
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 26, weight: .init(800))
        label.textColor = UIColor(named: "Colors/Black")
        label.numberOfLines = 0
        label.text = "ВХОД ИЛИ\nРЕГИСТРАЦИЯ"
        
        return label
    }()
    
    private lazy var phoneStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: phoneStackViewSubviews)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 7
        
        return stackView
    }()
    
    private lazy var codeNumberLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = UIColor(named: "Colors/InactiveTextField")
        label.layer.masksToBounds = true
        label.layer.cornerRadius = Constants.labelСornerRadius
        label.textColor = UIColor(named: "Colors/PlaceholderLabel")
        label.font = .systemFont(ofSize: 14, weight: .init(400))
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "+7"
        
        return label
    }()
    
    private lazy var phoneContainer: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton.init()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "Colors/ActiveButton")
        button.setTitleColor(UIColor(named: "Colors/White"), for: .normal)
        button.setTitle("Получить код", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .init(500))
        button.layer.cornerRadius = Constants.buttonСornerRadius
        
        return button
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = UIColor(named: "Colors/White")
        
        return indicator
    }()
    
    private lazy var footerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: footerStackViewSubviews)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 12
        
        return stackView
    }()
    
    private lazy var appleCircleLogoImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Auth/AppleCircleLogo")
        
        return imageView
    }()
    
    private lazy var vkCircleLogoImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Auth/VKCircleLogo")
        
        return imageView
    }()
    
    private lazy var okCircleLogoImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Auth/OKCircleLogo")
        
        return imageView
    }()
    
    private lazy var facebookCircleLogoImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Auth/FacebookCircleLogo")
        
        return imageView
    }()
    
}

// MARK: - Targets

private extension AuthViewImp {
    
    func addTargets() {
        loginButton.addTarget(self, action: #selector(onVerifyHandler), for: .touchUpInside)
    }
    
    @objc
    func onVerifyHandler() {
        self.onVerify?()
    }
    
}

// MARK: - KeyboardView

extension AuthViewImp {
    
    func connectKeyboard() {
        keyboardToken = [
            NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main) { [weak self] notification in
                guard let self = self else {
                    return
                }

                self.updateKeyboardWillShow(notification)
            },

        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main) { [weak self] notification in
                guard let self = self else {
                    return
                }

                self.updateKeyboardWillHide(notification)
            }
        ]
    }
    
    func updateKeyboardWillShow(_ notification: Notification) {
        let keyboardRect: CGRect? = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        
        guard let keyboardHeight = keyboardRect?.height else {
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.logoImageViewTopConstraint?.constant = -(keyboardHeight / 8)
            self.mainStackViewTopConstraint?.constant = -(keyboardHeight / 8)
            self.footerStackViewBottomConstraint?.constant = -keyboardHeight - (keyboardHeight / 16)

            self.apply(keyboardHeight: keyboardHeight)
        }
    }
    
    func updateKeyboardWillHide(_ notification: Notification) {
        let keyboardRect: CGRect? = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        
        guard let keyboardHeight = keyboardRect?.height else {
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.logoImageViewTopConstraint?.constant = 0
            self.mainStackViewTopConstraint?.constant = 0
            self.footerStackViewBottomConstraint?.constant = -Constants.Margin.bottom

            self.apply(keyboardHeight: keyboardHeight)
        }
    }
    
    func apply(keyboardHeight: CGFloat) {
        layoutIfNeeded()
    }
    
    func toDismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        endEditing(true)
    }
    
}

// MARK: - IndicationView

extension AuthViewImp {
    
    func displayLoadingIndicationState() {
        loginButton.setTitle("", for: .normal)
        indicator?.startAnimating()
        loginButton.isUserInteractionEnabled = false
        phoneContainer.isUserInteractionEnabled = false
    }
    
    func displayErrorIndicationState() {
        //
    }
    
    func displayEmptyIndicationState() {
        //
    }
    
    func hideIndication() {
        loginButton.setTitle("Получить код", for: .normal)
        indicator?.stopAnimating()
        loginButton.isUserInteractionEnabled = true
        phoneContainer.isUserInteractionEnabled = true
    }
    
}

// MARK: - ContainerView

extension AuthViewImp: ContainerView {
    
    enum ContainerID {
        case phone
    }
    
    private func container(by id: AuthViewImp.ContainerID) -> UIView {
        switch id {
        case .phone:
            return phoneContainer
        }
    }
    
    func addSubview(view: UIView, by id: AuthViewImp.ContainerID) {
        let container = container(by: id)
        
        let transition = CATransition()
        transition.duration = 1
        transition.type = CATransitionType.reveal
        container.layer.add(transition, forKey: nil)
        
        container.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                view.topAnchor.constraint(equalTo: container.topAnchor),
                view.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            ]
        )
    }
    
}
