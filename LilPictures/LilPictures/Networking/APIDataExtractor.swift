//
//  APIDataExtractor.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 03.05.2022.
//

import Foundation

class APIDataExtractor {
    private let apiManager: APIManager
    
    init(accessKey: String) {
        apiManager = APIManager(accessKey: accessKey)
    }
    
    //MARK: - Methods
    
    func fetchPhotos(query: String, count: Int, pages: Int, completion: @escaping (PhotoResultModel?) -> Void) {
        apiManager.searchPhotos(query: query, count: count, pages: pages) { [unowned self] data, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            let photoResult = decode(type: PhotoResultModel.self, from: data)
            completion(photoResult)
        }
    }
    
    func fetchPhotos(count: Int, completion: @escaping ([PhotoInfo]?) -> Void) {
        apiManager.getRandomPhotos(count: count) { [unowned self] data, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            let photos = decode(type: [PhotoInfo].self, from: data)
            completion(photos)
        }
    }
    
    //MARK: - Private methods
    
    private func decode<T: Decodable>(type: T.Type, from data: Data?) -> T? {
        guard let data = data else { return nil }

        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch let decodeError {
            print(decodeError)
            return nil
        }
    }
}
