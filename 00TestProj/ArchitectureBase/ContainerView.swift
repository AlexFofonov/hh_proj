//
//  ContainerView.swift
//  00TestProj
//
//  Created by Александр Фофонов on 15.04.2023.
//

import Foundation
import UIKit

protocol ContainerView {
    
    associatedtype ContainerID
    
    func addSubview(view: UIView, by id: ContainerID)
    
}
