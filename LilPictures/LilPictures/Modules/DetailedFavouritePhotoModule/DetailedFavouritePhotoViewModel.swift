//
//  DetailedFavouritePhotoViewModel.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 08.05.2022.
//

import Foundation

//MARK: - DetailedFavouritePhotoViewModelProtocol

protocol DetailedFavouritePhotoViewModelProtocol {
    var imageData: Data? { get }
}

//MARK: - DetailedFavouritePhotoViewModel

class DetailedFavouritePhotoViewModel: DetailedFavouritePhotoViewModelProtocol {
    var imageData: Data?
    
    init(imageData: Data?) {
        self.imageData = imageData
    }
    
}
