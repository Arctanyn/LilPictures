//
//  PhotoGalleryViewModel.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 03.05.2022.
//

import Foundation

//MARK: PhotoGalleryViewModelProtocol

protocol PhotoGalleryViewModelProtocol {
    var numberOfPhotos: Int { get }
    func fetchImages(completion: @escaping () -> Void)
    func searchImages(query: String, completion: @escaping () -> Void)
    func fetchAdditionalImages(completion: @escaping (Range<Int>) -> Void)
    func viewModelForCell(at indexPath: IndexPath) -> PhotoCollectionViewCellViewModelProtocol
    func photoIDForCell(at indexPath: IndexPath) -> String
    func showPhotoDetailsForSelectedCell(at indexPath: IndexPath)
    func createPhotoSearchViewModel() -> PhotoSearchViewModelProtocol
    func presentFavouritePhotos()
}

//MARK: - PhotoGalleryViewModel

class PhotoGalleryViewModel: PhotoGalleryViewModelProtocol {
    
    //MARK: Properties
    
    var numberOfPhotos: Int {
        photos.count
    }
    
    private let router: RouterProtocol
    private var photos: [PhotoInfo] = []
    private var searchResultPhotos: [PhotoInfo] = []
    private lazy var apiDataExtractor = APIDataExtractor(accessKey: fetchAPIAccessKey() ?? "")
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    //MARK: - Methods
    
    func fetchImages(completion: @escaping () -> Void) {
        apiDataExtractor.fetchPhotos(count: 30) { photos in
            guard let photos = photos else { return }
            self.photos = photos
            completion()
        }
    }
    
    func searchImages(query: String, completion: @escaping () -> Void) {
        apiDataExtractor.fetchPhotos(query: query, count: 30, pages: 1) { photoResult in
            guard let photos = photoResult?.results else { return }
            self.searchResultPhotos = photos
            completion()
        }
    }
    
    func fetchAdditionalImages(completion: @escaping (Range<Int>) -> Void) {
        let currentCount = photos.count
        apiDataExtractor.fetchPhotos(count: 30) { [unowned self] photos in
            guard let fetchedPhotos = photos else { return }
            self.photos += fetchedPhotos
            completion(currentCount..<self.photos.count)
        }
    }
    
    func viewModelForCell(at indexPath: IndexPath) -> PhotoCollectionViewCellViewModelProtocol {
        return PhotoCollectionViewCellViewModel(photo: photos[indexPath.item])
    }
    
    func photoIDForCell(at indexPath: IndexPath) -> String {
        return photos[indexPath.item].id ?? ""
    }
    
    func showPhotoDetailsForSelectedCell(at indexPath: IndexPath) {
        router.showPhotosDetailsViewController(with: photos[indexPath.row])
    }
    
    func createPhotoSearchViewModel() -> PhotoSearchViewModelProtocol {
        return PhotoSearchViewModel(photos: self.searchResultPhotos, router: router)
    }
    
    func presentFavouritePhotos() {
        router.showFavouritePhotosViewController()
    }
    
    //MARK: - Private methods
    
    private func fetchAPIAccessKey() -> String? {
        guard let path = Bundle.main.path(forResource: "Info", ofType: ".plist") else { return nil }
        do {
            let value = try NSDictionary(contentsOf: URL(fileURLWithPath: path), error: ())
            let accessKey = value.value(forKey: "AccessKey") as? String
            return accessKey
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
