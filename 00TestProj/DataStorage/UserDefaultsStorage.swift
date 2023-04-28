//
//  UserDefaultsStorage.swift
//  00TestProj
//
//  Created by Александр Фофонов on 01.02.2023.
//

import Foundation

final class UserDefaultsStorage: DataStorage {
    
    init(encoder: JSONEncoder, decoder: JSONDecoder, userDefaults: UserDefaults) {
        self.encoder = encoder
        self.decoder = decoder
        self.userDefaults = userDefaults
    }
    
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let userDefaults: UserDefaults
    
    func save<Value: Codable, Key: RawRepresentable>(value: Value, key: Key) where Key.RawValue == String {
        guard let data = try? encoder.encode(value) else {
            return
        }
        
        userDefaults.set(data, forKey: key.rawValue)
        userDefaults.synchronize()
    }
    
    func value<Value: Codable, Key: RawRepresentable>(key: Key) -> Value? where Key.RawValue == String {
        guard let data = userDefaults.data(forKey: key.rawValue) else {
            return nil
        }
        
        return try? decoder.decode(Value.self, from: data)
    }

}
