//
//  FavouritePhotosRouter.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 09.06.2022.
//

import UIKit

class FavouritePhotosRouter: Router {
    
    //MARK: Properties
    
    private let baseViewController: UIViewController
    private let assemblyBuilder: AssemblyBuilderProtocol
    
    //MARK: - Initialization
    
    required init(baseViewController: UIViewController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.baseViewController = baseViewController
        self.assemblyBuilder = assemblyBuilder
    }
    
    //MARK: - Methods
    
    func present(module: RouteModule, animated: Bool, context: Any?, completion: (() -> Void)?) {}
    
    func pushIntoNavigation(module: RouteModule, context: Any?, animated: Bool) {
        let viewController = prepareViewController(module: module, context: context)
        baseViewController.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)?) {
        baseViewController.dismiss(animated: true, completion: completion)
    }
    
    private func prepareViewController(module: RouteModule, context: Any?) -> UIViewController {
        switch module {
        case .detailedFavouritePhoto:
            guard let photo = context as? PhotoStorageModel else {
                fatalError(RoutingError.lackOfNecessaryContext.rawValue)
            }
            return assemblyBuilder.creteDetailedFavPhotoModule(photo: photo)
        default:
            fatalError(RoutingError.inappropriateModule.rawValue)
        }
    }
}
