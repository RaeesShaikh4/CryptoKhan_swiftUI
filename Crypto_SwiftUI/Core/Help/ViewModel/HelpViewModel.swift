//  HelpViewModel.swift
//  Crypto_SwiftUI

import Foundation
import SwiftUI
import Firebase

//MARK: Above all good below for image
class HelpViewModel: ObservableObject {
    
    private var db = Firestore.firestore()
    @Published var isSending: Bool = false
    
    enum HelpStatus: String {
        case pending
        case received
        case inProgress
        case resolved
        case closed
    }
    
    func sendFeedback(title: String, description: String, image: UIImage?, status: HelpStatus, completion: @escaping(Result<Void, Error>) -> Void) {
        guard !title.isEmpty, !description.isEmpty else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey:"Please fill the required fields"])))
            return
        }
        
        isSending = true
        
        var feedbackData: [String: Any] = [
            "title": title,
            "description": description,
            "status": status.rawValue,
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        // Check if there is an image
        if let image = image,
                   let resizedImageData = image.resizedTo1MB() {
                    
                    // Add the resized image data to the data
                    feedbackData["imageData"] = resizedImageData
                }
        
        // Upload feedback data to Firestore
        db.collection("HelpRequest").addDocument(data: feedbackData) { error in
            DispatchQueue.main.async {
                self.isSending = false
                if let error = error {
                    print("Error adding HelpRequest: \(error)")
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
}

// UIImage extension for resizing image
extension UIImage {
    func resizedTo1MB() -> Data? {
        let targetSize = CGSize(width: 1024, height: 1024) // Adjust the size as needed
        
        UIGraphicsBeginImageContext(targetSize)
        defer { UIGraphicsEndImageContext() }
        
        draw(in: CGRect(origin: .zero, size: targetSize))
        if let resizedImage = UIGraphicsGetImageFromCurrentImageContext() {
            return resizedImage.jpegData(compressionQuality: 1.0)
        }
        
        return nil
    }
}
