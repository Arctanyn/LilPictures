//
//  FavouritePhotosViewModel.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 07.05.2022.
//

import Foundation

protocol FavouritePhotosViewModelProtocol {
    var numberOfPhotos: Int { get }
    func fetchPhotos(completion: @escaping () -> Void)
    func deletePhoto(at indexPath: IndexPath, completion: @escaping () -> Void)
    func deleteAllPhotos(completion: @escaping () -> Void)
    func viewModelForCell(at indexPath: IndexPath) -> FavouritePhotoCellViewModelProtocol
}

class FavouritePhotosViewModel: FavouritePhotosViewModelProtocol {
    var numberOfPhotos: Int {
        photos.count
    }
        
    private var photos: [PhotoStorageModel] = []
    private let storageManager = StorageManager()
    
    func fetchPhotos(completion: @escaping () -> Void) {
        photos = storageManager.fetchPhotos()
    }
    
    func deletePhoto(at indexPath: IndexPath, completion: @escaping () -> Void) {
        storageManager.delete(photos[indexPath.item])
        fetchPhotos(completion: completion)
    }
    
    func deleteAllPhotos(completion: @escaping () -> Void) {
        storageManager.deleteAll()
        fetchPhotos(completion: completion)
    }
    
    func viewModelForCell(at indexPath: IndexPath) -> FavouritePhotoCellViewModelProtocol {
        FavouritePhotoCellViewModel(photo: photos[indexPath.item])
    }
}
