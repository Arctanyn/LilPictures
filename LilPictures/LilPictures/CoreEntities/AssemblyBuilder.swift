//
//  AssemblyBuilder.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 03.05.2022.
//

import UIKit

protocol AssemblyBuilderProtocol: AnyObject {
    func createPhotosGalleryModule() -> UIViewController
    func createPhotoDetailsModule(photo: PhotoInfo) -> UIViewController
    func createFavouritePhotosModule() -> UIViewController
    func creteDetailedFavPhotoModule(photo: PhotoStorageModel) -> UIViewController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    func createPhotosGalleryModule() -> UIViewController {
        let view = PhotoGalleryViewController()
        let router = PhotoGalleryRouter(baseViewController: view, assemblyBuilder: self)
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
        let router = FavouritePhotosRouter(baseViewController: view, assemblyBuilder: self)
        let viewModel = FavouritePhotosViewModel(router: router)
        view.viewModel = viewModel
        return view
    }
    
    func creteDetailedFavPhotoModule(photo: PhotoStorageModel) -> UIViewController {
        let view = DetailedFavouritePhotoViewController()
        let detailedFavouritePhotoViewModel = DetailedFavouritePhotoViewModel(photo: photo)
        view.viewModel = detailedFavouritePhotoViewModel
        return view
    }
}
