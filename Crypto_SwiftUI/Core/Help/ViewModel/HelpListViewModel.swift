
//MARK: Deletion Process
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class HelpListViewModel: ObservableObject {
    
    @Published var helpList: [HelpListModel] = []
    @Published var helpListID: [String] = []
    @Published var selectedHelpRequest: HelpListModel?
    
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    init() {
        fetchData()
    }
    
    deinit {
        listener?.remove()
    }
    
    func fetchData() {
        listener = db.collection("HelpRequest").addSnapshotListener({ querySnapshot, error in
            print("querySnapshot-----\(querySnapshot)")
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents \(error?.localizedDescription)")
                return
            }
            
            // card field ID fetched
            self.helpList = documents.compactMap { document in
                print("helpList scope called---")
                do {
                    print("document-----\(document.documentID)")
                    let decodedModel = try document.data(as: HelpListModel.self)
                    return decodedModel
                } catch {
                    print("Error decoding HelpListModel: \(error)")
                    return nil
                }
            }
            
            // Document ID fetched
            self.helpListID = documents.compactMap { document in
                print("helpListID scope called---")
                do {
                    print("document-----\(document.documentID)")
                    return document.documentID
                } catch {
                    print("Error decoding HelpListModel: \(error)")
                    return nil
                }
            }
            
        })
    }
    
    func removeDocument( helpRequest: HelpListModel,  ID: String) {
        guard let index = self.helpList.firstIndex(where: { $0.id == helpRequest.id }) else {
            print("Item not found in the array")
            return
        }
        
        let documentRef = db.collection("HelpRequest").document(ID)
        
        documentRef.delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                print("Document with ID \(helpRequest.id) deleted successfully")
                DispatchQueue.main.async {
                    if let index = self.helpList.firstIndex(where: { $0.id == helpRequest.id }) {
                        self.helpList.remove(at: index)
                        print("Item removed from the array")
                    } else {
                        print("Item not found in the array")
                    }
                }
            }
        }
    }
    
}


