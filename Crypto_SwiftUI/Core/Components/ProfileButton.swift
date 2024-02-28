import SwiftUI

struct ProfileButton: View {
    
    @Binding var isProfilePresented: Bool
    @State private var selectedImage: UIImage? = UIImage(systemName: "person.circle")
    @EnvironmentObject private var profileDataService: ProfileDataService
    @StateObject private var profileViewModel = ProfileViewModel()
    
    var body: some View {
        Button(action: {
            isProfilePresented = true
        }) {
            Image(uiImage: profileViewModel.selectedImage ?? UIImage(systemName: "person.circle")!)
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
                .background(
                    NavigationLink("", destination: ProfileView(isProfilePresented: $isProfilePresented), isActive: $isProfilePresented)
                        .hidden()
                )
        }
    }
}
   
struct ProfileButton_Previews: PreviewProvider {
    static var previews: some View {
        ProfileButton(isProfilePresented: .constant(false))
    }
}
