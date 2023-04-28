//
//  IndicationViewInput.swift
//  00TestProj
//
//  Created by Александр Фофонов on 14.04.2023.
//

import Foundation
import UIKit

public enum IndicationState {
    case loading
    case error
    case empty
}

public protocol IndicationViewInput: AnyObject {
    
    func displayIndication(state: IndicationState)
    func hideIndication()
    
}

public protocol IndicationView: IndicationViewInput {
    
    var indicator: UIActivityIndicatorView? { get set }
    
    func displayLoadingIndicationState()
    func displayErrorIndicationState()
    func displayEmptyIndicationState()
    
    func hideIndication()
    
}

extension IndicationView where Self: UIView {
    
    public func displayIndication(state: IndicationState) {
        switch (state) {
        case .loading:
            displayLoadingIndicationState()
        case .error:
            displayErrorIndicationState()
        case .empty:
            displayEmptyIndicationState()
        }
    }
    
    public func hideIndication() {
        hideIndication()
    }
    
}
