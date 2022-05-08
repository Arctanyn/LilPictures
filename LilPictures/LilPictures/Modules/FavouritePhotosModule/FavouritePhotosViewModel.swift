//
//  FavouritePhotosViewModel.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 07.05.2022.
//

import Foundation

protocol FavouritePhotosViewModelProtocol {
    var numberOfPhotos: Int { get }
    var viewModelDidChange: ((FavouritePhotosViewModelProtocol) -> Void)? { get set }
    func fetchPhotos()
    func deletePhoto(at indexPath: IndexPath, completion: @escaping () -> Void)
    func deleteAllPhotos(completion: @escaping () -> Void)
    func viewModelForCell(at indexPath: IndexPath) -> FavouritePhotoCellViewModelProtocol
    func showDetailedPhoto(with imageData: Data?)
}

class FavouritePhotosViewModel: FavouritePhotosViewModelProtocol {
    var numberOfPhotos: Int {
        photos.count
    }
    
    var viewModelDidChange: ((FavouritePhotosViewModelProtocol) -> Void)?
        
    private var photos: [PhotoStorageModel] = []
    private let storageManager = StorageManager()
    private let router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    func fetchPhotos() {
        photos = storageManager.fetchPhotos()
    }
    
    func deletePhoto(at indexPath: IndexPath, completion: @escaping () -> Void) {
        storageManager.delete(photos[indexPath.item])
        photos.remove(at: indexPath.item)
        viewModelDidChange?(self)
        completion()
    }
    
    func deleteAllPhotos(completion: @escaping () -> Void) {
        storageManager.deleteAll()
        photos = []
        viewModelDidChange?(self)
        completion()
    }
    
    func viewModelForCell(at indexPath: IndexPath) -> FavouritePhotoCellViewModelProtocol {
        FavouritePhotoCellViewModel(photo: photos[indexPath.item])
    }
    
    func showDetailedPhoto(with imageData: Data?) {
        router.showDetailedFavPhotoViewController(with: imageData)
    }
}
