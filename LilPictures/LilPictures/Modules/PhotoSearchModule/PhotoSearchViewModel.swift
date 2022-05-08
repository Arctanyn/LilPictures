//
//  PhotoSearchViewModel.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 07.05.2022.
//

import Foundation

protocol PhotoSearchViewModelProtocol {
    var numberOfPhotos: Int { get }
    func photoForCell(at indexPath: IndexPath) -> PhotoCollectionViewCellViewModelProtocol
    func photoIDForCell(at indexPath: IndexPath) -> String
    func showPhotoDetailsForCell(at indexPath: IndexPath)
}

class PhotoSearchViewModel: PhotoSearchViewModelProtocol {
    var numberOfPhotos: Int {
        photos.count
    }
    
    private let photos: [PhotoInfo]
    private let router: RouterProtocol
    
    init(photos: [PhotoInfo], router: RouterProtocol) {
        self.photos = photos
        self.router = router
    }
    
    func photoForCell(at indexPath: IndexPath) -> PhotoCollectionViewCellViewModelProtocol {
        return PhotoCollectionViewCellViewModel(photo: photos[indexPath.item])
    }
    
    func photoIDForCell(at indexPath: IndexPath) -> String {
        return photos[indexPath.item].id ?? ""
    }
    
    func showPhotoDetailsForCell(at indexPath: IndexPath) {
        router.showPhotosDetailsViewController(with: photos[indexPath.item])
    }
    
}
