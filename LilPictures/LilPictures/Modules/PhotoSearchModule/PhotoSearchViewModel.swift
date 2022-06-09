//
//  PhotoSearchViewModel.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 07.05.2022.
//

import Foundation

//MARK: - PhotoSearchViewModelProtocol

protocol PhotoSearchViewModelProtocol {
    var numberOfPhotos: Int { get }
    func photoForCell(at indexPath: IndexPath) -> PhotoCollectionViewCellViewModelProtocol
    func photoIDForCell(at indexPath: IndexPath) -> String
    func showPhotoDetailsForCell(at indexPath: IndexPath)
}

//MARK: - PhotoSearchViewModel

class PhotoSearchViewModel: PhotoSearchViewModelProtocol {
    var numberOfPhotos: Int {
        photos.count
    }
    
    weak var delegate: PhotoGalleryViewModelDelegate?
    
    private let photos: [PhotoInfo]
    
    init(photos: [PhotoInfo]) {
        self.photos = photos
    }
    
    func photoForCell(at indexPath: IndexPath) -> PhotoCollectionViewCellViewModelProtocol {
        return PhotoCollectionViewCellViewModel(photo: photos[indexPath.item])
    }
    
    func photoIDForCell(at indexPath: IndexPath) -> String {
        return photos[indexPath.item].id ?? ""
    }
    
    func showPhotoDetailsForCell(at indexPath: IndexPath) {
        delegate?.showDetails(photo: photos[indexPath.item])
    }
    
}
