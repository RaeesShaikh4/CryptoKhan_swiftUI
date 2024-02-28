////  HelpListViewModel.swift
////  Crypto_SwiftUI
//
//import Foundation
//import Firebase
//import FirebaseFirestoreSwift
//
//class HelpListViewModel: ObservableObject {
//    @Published var helpList: [HelpListModel] = []
//
//    @Published var selectedHelpRequest: HelpListModel?
//
//
//    private var db = Firestore.firestore()
//    private var listener: ListenerRegistration?
//
//    init() {
//        fetchData()
//    }
//
//    deinit {
//        listener?.remove()
//    }
//
//    func fetchData() {
//        listener = db.collection("HelpRequest").addSnapshotListener({ querySnapshot, error in
//            guard let documents = querySnapshot?.documents else {
//                print("Error fetching documents \(error?.localizedDescription)")
//                return
//            }
//
//            self.helpList = documents.compactMap { document in
//                do {
//                    let decodedModel = try document.data(as: HelpListModel.self)
//                    return decodedModel
//                } catch {
//                    print("Error decoding HelpListModel: \(error)")
//                    return nil
//                }
//            }
//
//        })
//    }
//
//}
//
//


//  HelpListViewModel.swift
//  Crypto_SwiftUI

import Foundation
import Firebase
import FirebaseFirestoreSwift

class HelpListViewModel: ObservableObject {
    @Published var helpList: [HelpListModel] = []

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
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents \(error?.localizedDescription)")
                return
            }

            self.helpList = documents.compactMap { document in
                do {
                    let decodedModel = try document.data(as: HelpListModel.self)
                    return decodedModel
                } catch {
                    print("Error decoding HelpListModel: \(error)")
                    return nil
                }
            }

        })
    }
    
    func deleteDocument(_ helpRequest: HelpListModel) {
        print("deleteDocument called---")
        if let index = helpList.firstIndex(where: { $0.id == helpRequest.id }) {
            db.collection("HelpRequest").document(helpRequest.id).delete { error in
                if let error = error {
                    print("Error deleting document: \(error.localizedDescription)")
                } else {
                    print("Document deleted successfully")
                }
            }

            helpList.remove(at: index)
        }
    }
}


