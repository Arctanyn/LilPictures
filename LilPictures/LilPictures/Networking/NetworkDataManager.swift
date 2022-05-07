//
//  NetworkDataExtractor.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 03.05.2022.
//

import Foundation

class NetworkDataManager {
    static let shared = NetworkDataManager()
    
    private var dataCache = NSCache<NSString, NSData>()
    
    func fetchData(from url: String, completion: @escaping (Data?) -> Void) {
        guard let strongURL = URL(string: url) else { return }
        if let cachedData = dataCache.object(forKey: strongURL.absoluteString as NSString) {
            completion(cachedData as Data)
        } else {
            DispatchQueue.global(qos: .userInteractive).async { 
                guard let data = try? Data(contentsOf: strongURL) else {
                    completion(nil)
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    self?.dataCache.setObject(data as NSData, forKey: strongURL.absoluteString as NSString)
                    completion(data)
                }
            }
        }
    }
}
