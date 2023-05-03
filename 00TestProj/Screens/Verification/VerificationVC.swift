//
//  VerificationVC.swift
//  00TestProj
//
//  Created by Александр Фофонов on 03.04.2023.
//

import UIKit

final class VerificationVC<View: VerificationView>: BaseVC<View> {
    
    init(
        verificationProvider: VerificationProvider,
        phone: String,
        timeLimit: Int
    ) {
        self.verificationProvider = verificationProvider
        self.phone = phone
        self.timeLimit = timeLimit
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let verificationProvider: VerificationProvider
    
    var onComplete: ((_ operationToken: String) -> Void)?
    
    private var phone: String
    private var timeLimit: Int
    
    private var timer: Timer?
    private var timeLeft: Int = 0
    private var appDidEnterBackgroundDate: Date?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.updatePhone(phone: phone)

        setupTimer()
        
        rootView.onRepeatSendCode = { [weak self] in
            guard let self = self else {
                return
            }
            
            self.repeatSendCode()
        }
        
        rootView.throwCode = { [weak self] code in
            guard let self = self else {
                return
            }
            
            self.verify(code: code)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc
    func onBack(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    @objc
    func applicationDidEnterBackground(_ notification: NotificationCenter) {
        appDidEnterBackgroundDate = Date()
    }

    @objc
    func applicationWillEnterForeground(_ notification: NotificationCenter) {
        updateTimeLeftAfterEnterForeground()
    }
    
    @objc
    func fireTimer() {
        timeLeft -= 1
     
        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil
            
            rootView.sendCodeIsActive(true)
        }
        
        rootView.updateTimer(with: timeLeft)
    }
    
}

// MARK: - Timer

private extension VerificationVC {
    
    func setupTimer() {
        timer = Timer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(fireTimer),
            userInfo: nil,
            repeats: true
        )
        
        guard let timer = timer else {
            return
        }
        
        timer.tolerance = 0.2
        RunLoop.current.add(timer, forMode: .common)
        
        timeLeft = timeLimit
    }
    
}

// MARK: - Logic

private extension VerificationVC {
    
    func repeatSendCode() {
        rootView.sendCodeIsActive(false)
        
        setupTimer()
        
        // Отпраляем код снова
    }
    
    func updateTimeLeftAfterEnterForeground() {
        guard let previousDate = appDidEnterBackgroundDate else {
            return
        }
        
        let calendar = Calendar.current
        
        let difference = calendar.dateComponents([.second], from: previousDate, to: Date())
        guard let seconds = difference.second else {
            return
        }
        
        timeLeft -= seconds
        if timeLeft <= 0 {
            timeLeft = 1
        }
    }
    
    func verify(code: String?) {
        guard validatePhone(text: code) == true else {
            return
        }
        
        onComplete?("Success")
    }
    
    func validatePhone(text: String?) -> Bool {
        guard let text = text, !text.isEmpty, text.count == 4 else {
            return false
        }
        
        // Проверка
        
        guard text == "1111" else {
            return false
        }
        
        return true
    }
    
}
