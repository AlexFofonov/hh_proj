//
//  ContainerViewController.swift
//  00TestProj
//
//  Created by Александр Фофонов on 15.04.2023.
//

import Foundation
import UIKit

protocol ContainerVC: UIViewController {
    
    associatedtype View: ContainerView
    
    var hostView: View { get }
    
}
