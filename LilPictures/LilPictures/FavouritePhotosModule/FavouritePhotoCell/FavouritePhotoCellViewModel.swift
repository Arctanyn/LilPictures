//
//  FavouritePhotoCellViewModel.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 07.05.2022.
//

import Foundation

protocol FavouritePhotoCellViewModelProtocol {
    var photoID: String { get }
    func fetchPhoto(completion: @escaping (Data?) -> Void)
}

class FavouritePhotoCellViewModel: FavouritePhotoCellViewModelProtocol {
    var photoID: String {
        photo.id ?? ""
    }
    
    private let photo: PhotoStorageModel
    
    init(photo: PhotoStorageModel) {
        self.photo = photo
    }
    
    func fetchPhoto(completion: @escaping (Data?) -> Void) {
        guard let url = photo.url else { return }
        NetworkDataManager.shared.fetchData(from: url) { imageData in
            DispatchQueue.main.async {
                completion(imageData)
            }
        }
    }
    
    
}
