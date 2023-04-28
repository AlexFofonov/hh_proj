//
//  BaseViewController.swift
//  00TestProj
//
//  Created by Александр Фофонов on 01.04.2023.
//

import UIKit

class BaseVC<View: UIView>: UIViewController {
    
    var rootView: View {
        view as! View
    }
    
    override func loadView() {
        self.view = View()
    }
    
}

extension BaseVC: ContainerVC where View: ContainerView {
    
    var hostView: View {
        rootView
    }
    
}
