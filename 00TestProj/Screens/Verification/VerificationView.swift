//
//  VerificationView.swift
//  00TestProj
//
//  Created by Александр Фофонов on 03.04.2023.
//

import UIKit

protocol VerificationView: UIView {
    
    var onRepeatSendCode: (() -> Void)? { get set }
    var throwCode: ((_ code: String?) -> Void)? { get set }

    func updatePhone(phone: String)
    func updateTimer(with timeLeft: Int)
    func sendCodeIsActive(_ isActive: Bool)
    
}
