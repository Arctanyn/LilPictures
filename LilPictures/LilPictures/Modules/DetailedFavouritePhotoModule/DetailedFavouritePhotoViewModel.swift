//
//  DetailedFavouritePhotoViewModel.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 08.05.2022.
//

import Foundation

protocol DetailedFavouritePhotoViewModelProtocol {
    var imageData: Data? { get }
}

class DetailedFavouritePhotoViewModel: DetailedFavouritePhotoViewModelProtocol {
    var imageData: Data?
    
    init(imageData: Data?) {
        self.imageData = imageData
    }
    
}
