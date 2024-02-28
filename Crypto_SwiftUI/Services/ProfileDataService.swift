//  ProfileDataService.swift
// Crypto_SwiftUI

import Foundation
import CoreData

class ProfileDataService: ObservableObject {
    private let container: NSPersistentContainer
    private let containerName: String = "ProfileContainer"
    private let entityName: String = "ProfileEntity"
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data for Profile! \(error)")
            }
        }
    }
    
    // MARK: Public functions
    
    func updateProfile(name: String, image: Data, bio: String) {
        do {
            if let entity = try getProfiles().first {
                update(entity: entity, name: name, image: image, bio: bio)
            } else {
                add(name: name, image: image, bio: bio)
            }
        } catch {
            print("Error updating profile: \(error)")
        }
    }
    
    // MARK: Internal functions
    
    internal func getProfiles() throws -> [ProfileEntity] {
        let request = NSFetchRequest<ProfileEntity>(entityName: entityName)
        return try container.viewContext.fetch(request)
    }
    
    // MARK: Private functions
    
    private func add(name: String, image: Data, bio: String) {
        let entity = ProfileEntity(context: container.viewContext)
        entity.name = name
        entity.image = image
        entity.bio = bio
        save()
    }
    
    private func update(entity: ProfileEntity, name: String, image: Data, bio: String) {
        entity.name = name
        entity.image = image
        entity.bio = bio
        save()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("Error saving profiles: \(error)")
        }
    }
}
