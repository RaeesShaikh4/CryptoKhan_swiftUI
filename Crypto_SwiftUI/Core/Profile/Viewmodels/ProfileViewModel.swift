//
//  ProfileViewModel.swift
//  Crypto_SwiftUI
//
//  Created by Vishal on 12/02/24.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var profile: ProfileEntity?
    private let profileDataService = ProfileDataService()
        
    init() {
        do {
            let profiles = try profileDataService.getProfiles()
            if let profile = profiles.first {
                self.profile = profile
                self.selectedImage = UIImage(data: profile.image ?? Data())
            }
        } catch {
            print("Error fetching profiles in ProfileViewModel:  \(error)")
        }
    }
    
    func updateProfile(name:String,image:Data,bio:String){
        profileDataService.updateProfile(name: name, image: image, bio: bio)
    }
 
}
