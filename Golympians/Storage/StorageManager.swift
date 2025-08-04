//
//  StorageManager.swift
//  Golympians
//
//  Created by Bernard Scott on 7/28/25.
//

import SwiftUI
import PhotosUI
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private init(){}
    
    private let storage = Storage.storage().reference() // Root ref loc of our DB
    private var profileImages: StorageReference {
        storage.child("profile_images")
    }
    private func userReference(userId: String) -> StorageReference {
        storage.child("users").child(userId)
    }
    
    func getPathForImage(path: String) -> StorageReference {
        Storage.storage().reference(withPath: path)
    }
    
    func getURLForImage(path: String) async throws -> URL {
        try await getPathForImage(path: path).downloadURL()
    }
    
    func getData(userId: String, path: String) async throws -> Data {
        try await storage.child(path).data(maxSize: 3 * 1024 * 1024)
    }
    
    func getImage(userId: String, path: String) async throws -> UIImage {
        let data = try await getData(userId: userId, path: path)
        guard let image = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }
        return image
    }
    
    func saveImage(data: Data) async throws -> (path: String, name: String) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let userId = try AuthenticationManager.shared.getAuthenticatedUser().uid
        
        let path = "\(UUID().uuidString).jpeg"
        
        let returnedMetaData = try await userReference(userId: userId).child(path).putDataAsync(data, metadata: metadata)
        
        guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
            throw URLError(.badServerResponse)
        }
        
        return (returnedPath, returnedName)
    }
    
    func saveImage(image: UIImage) async throws -> (path: String, name: String) {
        guard let data = image.jpegData(compressionQuality: 1) else {
            throw URLError(.badURL)
        }
        
        return try await saveImage(data: data)
    }
    
    func deleteImage(path: String) async throws {
        try await getPathForImage(path: path).delete()
    }
}
