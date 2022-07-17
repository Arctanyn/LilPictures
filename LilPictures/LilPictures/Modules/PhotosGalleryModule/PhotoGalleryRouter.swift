//
//  PhotoGalleryRouter.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 09.06.2022.
//

import UIKit

class PhotoGalleryRouter: Router {
    
    //MARK: Properties
    
    private let baseViewController: UIViewController
    private let assemblyBuilder: AssemblyBuilderProtocol
    
    //MARK: - Initialization
    
    required init(baseViewController: UIViewController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.baseViewController = baseViewController
        self.assemblyBuilder = assemblyBuilder
    }
    
    //MARK: - Methods
    
    func present(module: RouteModule, animated: Bool, context: Any?, completion: (() -> Void)?) {
        let destinationViewController = prepareViewController(with: module, context: context)
        destinationViewController.modalPresentationStyle = !(destinationViewController is PhotoDetailsViewController) ? .fullScreen : .pageSheet
        baseViewController.present(destinationViewController, animated: animated, completion: completion)
    }
    
    func pushIntoNavigation(module: RouteModule, context: Any?, animated: Bool) {
        let viewController = prepareViewController(with: module)
        baseViewController.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)?) {}
    
    //MARK: - Private methods
    
    private func prepareViewController(with module: RouteModule, context: Any? = nil) -> UIViewController {
        switch module {
        case .photoDetails:
            guard let photo = context as? PhotoInfo else {
                fatalError(RoutingError.lackOfNecessaryContext.rawValue)
            }
            return assemblyBuilder.createPhotoDetailsModule(photo: photo)
        case .favourites:
            return assemblyBuilder.createFavouritePhotosModule()
        default:
            fatalError(RoutingError.inappropriateModule.rawValue)
        }
    }
}
