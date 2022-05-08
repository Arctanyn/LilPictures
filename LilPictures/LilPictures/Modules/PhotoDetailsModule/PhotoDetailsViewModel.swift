//
//  PhotoDetailsViewModel.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 04.05.2022.
//

import Foundation

protocol PhotoDetailsViewModelProtocol {
    var isFavourite: Bool { get }
    var userName: String? { get }
    var photoDescription: String? { get }
    var viewModelDidChange: ((PhotoDetailsViewModelProtocol) -> Void)? { get set }
    func fetchUserProfilePhoto(completion: @escaping (Data?) -> Void)
    func fetchDetailedPhoto(completion: @escaping (Data?) -> Void)
    func fetchFullPhoto(completion: @escaping (Data?) -> Void)
    func toggleFavouriteStatus()
}

class PhotoDetailsViewModel: PhotoDetailsViewModelProtocol {
    var isFavourite: Bool {
        get {
            storageManager.isObjectInStorage(photo)
        }
        set {
            if newValue {
                storageManager.save(photo)
            } else {
                storageManager.delete(photo)
            }
            viewModelDidChange?(self)
        }
    }
    
    var userName: String? {
        photo.user?.username
    }
    
    var photoDescription: String? {
        photo.description
    }
    
    var viewModelDidChange: ((PhotoDetailsViewModelProtocol) -> Void)?
    
    private let photo: PhotoInfo
    private let storageManager = StorageManager()
    
    init(photo: PhotoInfo) {
        self.photo = photo
    }
    
    func fetchUserProfilePhoto(completion: @escaping (Data?) -> Void) {
        NetworkDataManager.shared.fetchData(from: photo.user?.profileImage["medium"] ?? "") { userImageData in
            completion(userImageData)
        }
    }
    
    func fetchDetailedPhoto(completion: @escaping (Data?) -> Void) {
        guard let url = photo.urls?["regular"] else {
            completion(nil)
            return
        }
        NetworkDataManager.shared.fetchData(from: url) { imageData in
            completion(imageData)
        }
    }
    
    func fetchFullPhoto(completion: @escaping (Data?) -> Void) {
        guard let url = photo.urls?["regular"] else {
            completion(nil)
            return
        }
        NetworkDataManager.shared.fetchData(from: url) { imageData in
            completion(imageData)
        }
    }
    
    func toggleFavouriteStatus() {
        isFavourite.toggle()
    }
}
