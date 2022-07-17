//
//  DetailedFavouritePhotoViewModel.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 08.05.2022.
//

import Foundation

//MARK: - DetailedFavouritePhotoViewModelProtocol

protocol DetailedFavouritePhotoViewModelProtocol {
    func fetchPhoto(completion: @escaping (Data?) -> Void)
}

//MARK: - DetailedFavouritePhotoViewModel

class DetailedFavouritePhotoViewModel: DetailedFavouritePhotoViewModelProtocol {
    private let photo: PhotoStorageModel
    
    init(photo: PhotoStorageModel) {
        self.photo = photo
    }
    
    func fetchPhoto(completion: @escaping (Data?) -> Void) {
        guard let url = photo.baseURL else { return }
        NetworkDataManager.shared.fetchData(from: url, completion: completion)
    }
    
}
