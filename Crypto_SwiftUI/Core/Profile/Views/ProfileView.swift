
import SwiftUI

struct ProfileView: View,ImagePickerDelegate {
   
    
    @Binding var isProfilePresented: Bool
    @State private var selectedImage: UIImage? = UIImage(systemName: "person.circle")
    @State private var isImagePickerPresented: Bool = false
    @State private var isImagePickerActive: Bool = false
    @EnvironmentObject private var profileDataService: ProfileDataService
    @StateObject private var profileViewModel = ProfileViewModel()
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea(.all)
            
            profileSection
            
        }
        .onChange(of: isImagePickerPresented) { newValue in
            if !newValue {
                isImagePickerActive = false
            }
        }
        .onChange(of: selectedImage) { newImage in
            print("Selected Image Updated")
        }
        
    }
    // ImagePickerDelegate method
    func didSelectImage(_ image: UIImage?, imageName: String?) {
        selectedImage = image
        if let imageData = image?.jpegData(compressionQuality: 1.0) {
            profileViewModel.updateProfile(name: "Raees Shaikh", image: imageData, bio: "ios developer")
        }
    }
}

struct ProfileRow: View {
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(Color.theme.accent)
                .font(.headline)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(Color.theme.accent)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .background(RoundedRectangle(cornerRadius: 16)
            .fill(Color.theme.background.opacity(0.5)))
    }
}

extension ProfileView {
    private var profileSection: some View {
        VStack(spacing: 10){
            NavigationLink(destination: ImagePicker(selectedImage: $profileViewModel.selectedImage , isImagePickerPresented: $isImagePickerPresented, delegate: self), isActive: $isImagePickerPresented) {
                EmptyView()
            }
           
            Button(action: {
                isImagePickerPresented.toggle()
            }) {
                Image(uiImage: profileViewModel.selectedImage ?? UIImage(systemName: "person.circle")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 130, height: 130)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(lineWidth: 0.5).foregroundColor(Color.theme.accent))
            }
            .background(
            )
            .buttonStyle(BorderlessButtonStyle())
            .onTapGesture {
                isImagePickerActive = true
            }
            
            Text("Raees Shaikh")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(Color.theme.accent)
                .padding(.top)
            
            Text("ios Developer")
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            
            VStack(spacing: 5) {
                Text("Portfolio Value")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.theme.secondaryText)
                
                Text("$123,456.78")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.accent)
            }
            
            HStack {
                Image(systemName: "arrow.up.right.circle.fill")
                    .font(.title3)
                    .foregroundColor(Color.theme.green)
                
                Text("+2.54%")
                    .font(.subheadline)
                    .foregroundColor(Color.theme.green)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 16)
                .fill(Color.theme.background.opacity(0.7)))
            
            
            NavigationLink(destination: Text("My Account")) {
                ProfileRow(title: "My Account")
            }
            
            NavigationLink(destination: Text("Two-Factor Authentication")) {
                ProfileRow(title: "Two-Factor Authentication")
            }
            
            NavigationLink(destination: HelpListView()) {
                ProfileRow(title: "Help")
            }
            
            NavigationLink(destination: Text("Log Out")) {
                ProfileRow(title: "Log Out")
            }
            
        }
        .padding()
    }
}
