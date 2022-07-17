//
//  FavouritePhotosViewModel.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 07.05.2022.
//

import Foundation

//MARK: - FavouritePhotosViewModelProtocol

protocol FavouritePhotosViewModelProtocol {
    var numberOfPhotos: Int { get }
    var viewModelDidChange: ((FavouritePhotosViewModelProtocol) -> Void)? { get set }
    func fetchPhotos()
    func deletePhoto(at indexPath: IndexPath, completion: @escaping () -> Void)
    func deleteAllPhotos(completion: @escaping () -> Void)
    func viewModelForCell(at indexPath: IndexPath) -> FavouritePhotoCellViewModelProtocol
    func showDetailedPhotoForCell(at indexPath: IndexPath)
}

//MARK: - FavouritePhotosViewModel

class FavouritePhotosViewModel: FavouritePhotosViewModelProtocol {
    var numberOfPhotos: Int {
        photos.count
    }
    
    var viewModelDidChange: ((FavouritePhotosViewModelProtocol) -> Void)?
    
    private let router: Router
    private var photos: [PhotoStorageModel] = []
    private let storageManager = StorageManager()
    
    init(router: Router) {
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
        photos.removeAll()
        viewModelDidChange?(self)
        completion()
    }
    
    func viewModelForCell(at indexPath: IndexPath) -> FavouritePhotoCellViewModelProtocol {
        FavouritePhotoCellViewModel(photo: photos[indexPath.item])
    }

    func showDetailedPhotoForCell(at indexPath: IndexPath) {
        router.pushIntoNavigation(module: .detailedFavouritePhoto, context: photos[indexPath.item], animated: true)
    }
}
