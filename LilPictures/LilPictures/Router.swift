//
//  Router.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 03.05.2022.
//

import UIKit

protocol BasicRouterRequirementsProtocol {
    var assemblyBuilder: AssemblyBuilderProtocol { get set }
    var navigationController: UINavigationController { get set }
}

protocol RouterProtocol: BasicRouterRequirementsProtocol {
    func setInitialViewController()
    func showPhotosDetailsViewController(with photo: PhotoInfo)
    func showFavouritePhotosViewController()
    func showDetailedFavPhotoViewController(with imageData: Data?)
}

class Router: RouterProtocol {
    
    var assemblyBuilder: AssemblyBuilderProtocol
    
    var navigationController: UINavigationController
    
    
    init(assemblyBuilder: AssemblyBuilderProtocol, navigationController: UINavigationController) {
        self.assemblyBuilder = assemblyBuilder
        self.navigationController = navigationController
    }
    
    func setInitialViewController() {
        let photosGalleryViewController = assemblyBuilder.createPhotosGalleryModule(router: self)
        navigationController.viewControllers = [photosGalleryViewController]
    }
    
    func showPhotosDetailsViewController(with photo: PhotoInfo) {
        let photoDetailsViewController = assemblyBuilder.createPhotoDetailsModule(photo: photo)
        navigationController.present(photoDetailsViewController, animated: true)
    }
    
    func showFavouritePhotosViewController() {
        let favouritePhotosViewController = assemblyBuilder.createFavouritePhotosModule(router: self)
        navigationController.pushViewController(favouritePhotosViewController, animated: true)
    }
    
    func showDetailedFavPhotoViewController(with imageData: Data?) {
        let detailedFavPhotoViewController = assemblyBuilder.creteDetailedFavPhotoModule(imageData: imageData)
        navigationController.pushViewController(detailedFavPhotoViewController, animated: true)
    }
}
