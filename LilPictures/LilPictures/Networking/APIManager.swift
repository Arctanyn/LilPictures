//
//  APIManager.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 03.05.2022.
//

import Foundation

fileprivate enum APIBase: String {
    case scheme = "https"
    case host = "api.unsplash.com"
}

fileprivate enum APIType {
    case random
    case search
    
    var path: String {
        switch self {
        case .random:
            return "/photos/random"
        case .search:
            return "/search/photos"
        }
    }
}

//MARK: - APIManager

class APIManager {
    private let accessKey: String
    private let networkService = NetworkService()
    
    init(accessKey: String) {
        self.accessKey = accessKey
    }
    
    //MARK: - Methods
    
    func getRandomPhotos(count: Int, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = networkService.createURL(
            scheme: APIBase.scheme.rawValue,
            host: APIBase.host.rawValue,
            path: APIType.random.path,
            queryParameters: prepareRandomPhotosParameters(count: count)
        ) else { return }
        
        let request = networkService.createRequest(
            with: url,
            headers: prepareHeaders()
        )
        
        let task = networkService.createTask(with: request, completion: completion)
        task.resume()
    }
    
    func searchPhotos(query: String, count: Int, pages: Int, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = networkService.createURL(
            scheme: APIBase.scheme.rawValue,
            host: APIBase.host.rawValue,
            path: APIType.search.path,
            queryParameters: prepareSearchParameters(
                query: query,
                page: pages,
                perPage: count
            )
        ) else { return }
        
        let request = networkService.createRequest(with: url, headers: prepareHeaders())
        
        let task = networkService.createTask(with: request, completion: completion)
        task.resume()
    }
    
    //MARK: - Private methods
    
    private func prepareRandomPhotosParameters(count: Int) -> [String: String] {
        var parameters: [String: String] = [:]
        parameters["count"] = String(count)
        return parameters
    }
    
    private func prepareSearchParameters(query: String, page: Int, perPage: Int) -> [String: String] {
        var parameters: [String: String] = [:]
        parameters["query"] = query
        parameters["page"] = String(page)
        parameters["per_page"] = String(perPage)
        return parameters
    }
    
    private func prepareHeaders() -> [String: String] {
        var headers: [String: String] = [:]
        headers["Authorization"] = "Client-ID \(accessKey)"
        return headers
    }
}
