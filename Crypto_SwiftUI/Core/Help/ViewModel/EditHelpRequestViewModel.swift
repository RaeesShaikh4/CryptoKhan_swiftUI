// MARK: below for get document id
import Foundation
import Firebase
import SwiftUI
import FirebaseFirestore

class EditHelpRequestViewModel: ObservableObject {
    
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    @Published var helpRequest: HelpListModel
    @Published var helpRequestID: String = ""
    
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var selectedImage: UIImage?
    @Published var status: String = ""
    @Published var imageName: String?
    
    
    init(helpRequest: HelpListModel, title: String, description: String) {
           self.helpRequest = helpRequest
           self.title = title
           self.description = description
       }
    
    deinit {
        listener?.remove()
    }
    
    func fetchData() {
        print("EditHelpRequestViewModel fetchData called---")
        
        listener = db.collection("HelpRequest").addSnapshotListener({ querySnapshot, error in
            
            print("querySnapshot-----\(querySnapshot)")
            
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents \(error?.localizedDescription)")
                return
            }
            
            // card field ID fetched
            if let firstHelpRequest = documents.compactMap({ document in
                print("helpRequest scope called---")
                do {
                    print("document-----\(document.documentID)")
                    let decodedModel = try document.data(as: HelpListModel.self)
                    return decodedModel
                } catch {
                    print("Error decoding HelpListModel: \(error)")
                    return nil
                }
            }).first {
                self.helpRequest = firstHelpRequest
            } else {
                print("No valid documents found")
            }
            
            
            // Document ID fetched
            if let firstDocumentID = documents.first?.documentID {
                self.helpRequestID = firstDocumentID
                print("Document ID fetched: \(firstDocumentID)")
            } else {
                print("No valid documents found")
            }
            
        })
    }
    
    
    func updateData(helpRequest: HelpListModel, ID: String, completion: @escaping (Bool) -> Void) {
        print("updateData called---")
        
        let documentReference = db.collection("HelpRequest").document(ID)
        
        var updatedData: [String: Any] = [:]
        
        if !self.title.isEmpty && self.title != helpRequest.title {
            updatedData["title"] = self.title
        }
        
        if !self.description.isEmpty && self.description != helpRequest.description {
            updatedData["description"] = self.description
        }
        
        if let selectedImage = self.selectedImage {
            updatedData["imageData"] = selectedImage
        }
        
        updatedData["timestamp"] = FieldValue.serverTimestamp()
        
        print("Updated Data: \(updatedData)")
        print("Title: \(self.title)")
        print("Description: \(self.description)")

        documentReference.setData(updatedData, merge: true) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Document successfully updated \(ID)")
                completion(true)
            }
        }
    }
    
}

