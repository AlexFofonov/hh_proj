//
//  AuthController.swift
//  00TestProj
//
//  Created by Александр Фофонов on 01.04.2023.
//

import UIKit

final class AuthVC<View: AuthView>: BaseVC<View> {
    
    typealias Complete = (_ operationToken: String) -> Void
    
    enum ValidatePhoneError: LocalizedError {
        case wrongFormat
        case fieldIsEmpty

        var errorDescription: String? {
            switch self {
            case .wrongFormat:
                return "Неверный формат телефона"
            case .fieldIsEmpty:
                return "Поле не может быть пустым"
            }
        }
    }
    
    private let authProvider: AuthProvider
    
    var onVerification: ((_ phone: String, _ completion: @escaping Complete) -> Void)?
    
    private var phone: String?
    
    init(
        authProvider: AuthProvider
    ) {
        self.authProvider = authProvider

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.onVerify = { [weak self] in
            guard let self = self else {
                return
            }
            
            self.verify()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        rootView.connectKeyboard()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        rootView.disconnectKeyboard()
    }
    
    func change(phone: String?) {
        self.phone = phone
    }
    
}

// MARK: - Logic

extension AuthVC {
    
    func verify() {
        guard validatePhone() == nil else {
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
            return
        }
        
        guard let phone = phone else {
            return
        }
        
        rootView.displayIndication(state: .loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.rootView.hideIndication()
            
            self.onVerification?(phone) { operationToken in

                // Выполняем Complete
                
            }
        }
    }
    
    func validatePhone() -> LocalizedError? {
        guard let phone = phone, !phone.isEmpty else {
            return ValidatePhoneError.fieldIsEmpty
        }
        
        guard phone.count == 10 else {
            return ValidatePhoneError.wrongFormat
        }
        
        return nil
    }
    
}
