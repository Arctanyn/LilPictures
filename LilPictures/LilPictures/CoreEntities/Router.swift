//
//  Router.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 09.06.2022.
//

import UIKit

//MARK: - RouteModule

enum RouteModule {
    case photoGallery
    case photoDetails
    case favourites
    case detailedFavouritePhoto
}

//MARK: - RoutingError

enum RoutingError: String {
    case lackOfNecessaryContext = "Error: Attempt to call the module without providing the necessary parameters (Change the context to match the expected)"
    case inappropriateModule = "Error: Attempt to call an inappropriate module (Try changing the requested module)"
}

//MARK: - Router

protocol Router {
    
    init(baseViewController: UIViewController, assemblyBuilder: AssemblyBuilderProtocol)

    func present(module: RouteModule, animated: Bool, context: Any?, completion: (() -> Void)?)
    
    func pushIntoNavigation(module: RouteModule, context: Any?, animated: Bool)
    
    func dismiss(animated: Bool, completion: (() -> Void)?)
}
