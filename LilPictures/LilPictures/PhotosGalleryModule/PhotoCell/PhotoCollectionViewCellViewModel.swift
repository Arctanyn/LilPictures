//
//  PhotoCollectionViewCellViewModel.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 03.05.2022.
//

import Foundation

protocol PhotoCollectionViewCellViewModelProtocol {
    var photoID: String { get }
    init(photo: PhotoInfo)
    func fetchPhoto(completion: @escaping (Data?) -> Void)
}

class PhotoCollectionViewCellViewModel: PhotoCollectionViewCellViewModelProtocol {
    var photoID: String {
        photo.id ?? ""
    }
    
    private let photo: PhotoInfo
    
    required init(photo: PhotoInfo) {
        self.photo = photo
    }
    
    func fetchPhoto(completion: @escaping (Data?) -> Void) {
        guard let url = photo.urls?["small"] else {
            completion(nil)
            return
        }
        NetworkDataManager.shared.fetchData(from: url) { imageData in
            DispatchQueue.main.async {
                completion(imageData)
            }
        }
    }
    
    
}
