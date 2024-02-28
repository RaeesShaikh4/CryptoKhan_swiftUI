//  ImagePicker.swift
//  Crypto_SwiftUI

import Foundation
import SwiftUI
import UIKit

protocol ImagePickerDelegate {
//    func didSelectImage(_ image: UIImage?)
    func didSelectImage(_ image: UIImage?, imageName: String?)
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isImagePickerPresented: Bool
    var delegate: ImagePickerDelegate?
    
    @Environment(\.dismiss) var dismiss // Added dismiss environment variable


    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
       

        init(parent: ImagePicker) {
            self.parent = parent
        }
        
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let uiImage = info[.originalImage] as? UIImage {
//                parent.selectedImage = uiImage
//
//                let imageData = uiImage.jpegData(compressionQuality: 1.0)
//                parent.delegate?.didSelectImage(uiImage)
//                // Dismiss the picker directly using environment variable
//                parent.dismiss()
//
//                print("converted image: \(imageData!)")
//            }
//
//            parent.isImagePickerPresented = false
//            picker.dismiss(animated: true)
//        }
        // for url and name
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage,
               let imageUrl = info[.imageURL] as? URL {
                
                // Extract the image name from the URL
                let imageName = imageUrl.lastPathComponent
                
                parent.selectedImage = uiImage
                parent.delegate?.didSelectImage(uiImage, imageName: imageName)

                
                // Dismiss the picker directly using environment variable
                parent.dismiss()
                
                print("Selected Image Name: \(imageName)")
            }
            
            parent.isImagePickerPresented = false
            picker.dismiss(animated: true)
        }

        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isImagePickerPresented = false
            picker.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary // Use photo library directly

     
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
