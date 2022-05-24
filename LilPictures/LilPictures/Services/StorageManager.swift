//
//  StorageManager.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 07.05.2022.
//

import UIKit
import CoreData

class StorageManager {
    
    private var context: NSManagedObjectContext?
    
    init() {
        context = (UIApplication.shared.delegate as? AppDelegate)?.persistantContainer.viewContext
    }
    
    //MARK: - Methods
    
    func save(_ photo: PhotoInfo) {
        guard
            let context = context,
            let entityDescription = NSEntityDescription.entity(forEntityName: "PhotoStorageModel", in: context),
            let photoModel = NSManagedObject(entity: entityDescription, insertInto: context) as? PhotoStorageModel
        else { return }
        
        photoModel.url = photo.urls?["regular"]
        photoModel.identifier = photo.id
        
        saveContext()
    }
    
    func fetchPhotos() -> [PhotoStorageModel] {
        guard let context = context else { return [] }
        let fetchRequest: NSFetchRequest<PhotoStorageModel> = PhotoStorageModel.fetchRequest()
        do {
            let photos = try context.fetch(fetchRequest)
            return photos
        } catch let fetchError {
            print(fetchError.localizedDescription)
            return []
        }
    }
    
    func delete(_ photo: PhotoInfo) {
        guard let photoModel = findObjectInStorage(photo) else { return }
        context?.delete(photoModel)
        saveContext()
    }
    
    func delete(_ photo: PhotoStorageModel) {
        guard let context = context else { return }
        context.delete(photo)
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func deleteAll() {
        guard let context = context else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PhotoStorageModel")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let deleteError {
            print(deleteError.localizedDescription)
        }
    }
    
    func isObjectInStorage(_ photo: PhotoInfo) -> Bool {
        guard findObjectInStorage(photo) != nil else { return false }
        return true
    }
    
    //MARK: - Private methods
    
    private func findObjectInStorage(_ photo: PhotoInfo) -> PhotoStorageModel? {
        guard let context = context else { return nil }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PhotoStorageModel")
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", photo.id ?? "")
        
        do {
            guard
                let results = try context.fetch(fetchRequest) as? [PhotoStorageModel],
                !results.isEmpty,
                let photoModel = results.first
            else { return nil }
            return photoModel
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func saveContext() {
        guard let context = context else { return }
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
