//
//  AuthView.swift
//  00TestProj
//
//  Created by Александр Фофонов on 01.04.2023.
//

import UIKit

protocol AuthView: UIView, KeyboardableViewInput, IndicationView {
    
    var onVerify: (() -> Void)? { get set }
    
}
