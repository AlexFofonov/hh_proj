//
//  DataStorage.swift
//  00TestProj
//
//  Created by Александр Фофонов on 01.02.2023.
//

import Foundation

protocol DataStorage {
    
    func save<Value: Codable, Key: RawRepresentable>(value: Value, key: Key) where Key.RawValue == String
    func value<Value: Codable, Key: RawRepresentable>(key: Key) -> Value? where Key.RawValue == String
    
}
