//
//  AssemblyBuilder.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 03.05.2022.
//

import UIKit

protocol AssemblyBuilderProtocol: AnyObject {
    func createPhotosGalleryModule(router: RouterProtocol) -> UIViewController
    func createPhotoDetailsModule(photo: PhotoInfo) -> UIViewController
    func createFavouritePhotosModule() -> UIViewController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    func createPhotosGalleryModule(router: RouterProtocol) -> UIViewController {
        let view = PhotoGalleryViewController()
        let photosGalleryViewModel = PhotoGalleryViewModel(router: router)
        view.viewModel = photosGalleryViewModel
        return view
    }
    
    func createPhotoDetailsModule(photo: PhotoInfo) -> UIViewController {
        let view = PhotoDetailsViewController()
        let photoDetailsViewModel = PhotoDetailsViewModel(photo: photo)
        view.viewModel = photoDetailsViewModel
        return view
    }
    
    func createFavouritePhotosModule() -> UIViewController {
        let view = FavouritePhotosViewController()
        let favouritePhotosViewModel = FavouritePhotosViewModel()
        view.viewModel = favouritePhotosViewModel
        return view
    }
}
