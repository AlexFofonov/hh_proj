//
//  BootstrapDataProvider.swift
//  00TestProj
//
//  Created by Александр Фофонов on 26.02.2023.
//

import Foundation

class BootstrapDataProvider {
    
    enum Error: Swift.Error {
        case unknown
    }
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    private let apiClient: ApiClient
    
    // как можно чаще избегай хранение данных внутри классов
    
    func loadData(completion: @escaping (Result<(profile: Profile?, city: City?), Swift.Error>) -> Void) {
        
        let dispatchGroup = DispatchGroup()
        
        var profileResult: Result<ResponseBody<ProfileResponseData>, ApiClient.Error>?
        var cityResult: Result<ResponseBody<CityResponseData>, ApiClient.Error>?
    
        dispatchGroup.enter()
        self.apiClient.request(
            ProfileResponseData.self,
            url: Bundle.main.url(forResource: "Profile", withExtension: "json")
        ) { result in
            
            profileResult = result
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        self.apiClient.request(
            CityResponseData.self,
            url: Bundle.main.url(forResource: "City", withExtension: "json")
        ) { result in
            
            cityResult = result
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            guard let profileResult = profileResult, let cityResult = cityResult else {
                return
            }
            
            switch (profileResult, cityResult) {
            case (.success(let profile), .success(let city)):
                completion(.success((profile: profile.data?.profile, city: city.data?.city)))
            default:
                completion(.failure(Error.unknown))
            }
        }
    }
    
}
