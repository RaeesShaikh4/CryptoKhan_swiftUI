
import SwiftUI
struct EditHelpRequest: View {
    @State private var request: String = ""
    @State private var description: String = ""
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented: Bool = false
    @State private var isImagePickerActive: Bool = false
    @State private var imageName: String?
    @State private var isPresented = true
    
    var editRequestID: String = ""
    var helpRequest: HelpListModel
    @StateObject var viewModel: EditHelpRequestViewModel
    
    var cancelAction: (() -> Void)?
    var onUpdate: (() -> Void)?
    
    
    init(editRequestID: String, helpRequest: HelpListModel, cancelAction: (() -> Void)?,onUpdate: (() -> Void)? ) {
        self.editRequestID = editRequestID
        self.helpRequest = helpRequest
        self.cancelAction = cancelAction
        self._viewModel = StateObject(wrappedValue: EditHelpRequestViewModel(helpRequest: helpRequest, title: helpRequest.title, description: helpRequest.description))
        self.onUpdate = onUpdate
    }
    
    var body: some View {
        
        if helpRequest.status == "pending" {
            VStack {
                Image(systemName: "square.and.pencil.circle.fill")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.green.opacity(0.9))
                
                Text("Update your request..")
                    .font(.title3)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Spacer()
                textFieldsSection
                Spacer()
                imageUploadSection
                Spacer()
                buttonSection
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            
        } else {
            VStack {
                placeHoderSection
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .opacity(isPresented ? 1 : 0)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    dismissAlert()
                }
            }
        }
        
    }
       
    
    private var textFieldsSection: some View {
        VStack(spacing: 20) {
            
            TextField("Enter your request here...", text: $viewModel.title)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemGray5)))
                .foregroundColor(Color.theme.textfieldFG)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            TextEditor(text: $viewModel.description)
                .frame(height: 135)
                .cornerRadius(10)
                .colorMultiply(Color(UIColor.systemGray5))
                .foregroundColor(Color.theme.accent)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
        .padding(.top, 10)
        .padding(.horizontal, 10)
    }
    
    private var imageUploadSection: some View {
        HStack(spacing: 16) {
            Spacer()
            
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .padding(.bottom, 4)
                
                if let imageName = imageName {
                    Text(imageName)
                        .font(.caption)
                        .foregroundColor(Color.theme.accent)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                }
            }
            
            CircleButtonView(iconName: selectedImage == nil ? "photo.on.rectangle.angled" : "checkmark")
                .scaledToFill()
                .frame(width: 50, height: 50)
                .animation(.none)
                .onTapGesture {
                    isImagePickerPresented.toggle()
                    isImagePickerActive = true
                }
        }
        .padding(.trailing, 16)
        .padding(.top, 10)
    }
    
    private var buttonSection: some View {
        HStack(spacing: 16) {
            Button(action: {
                print("Update button tapped---")
                viewModel.updateData(helpRequest: helpRequest, ID: editRequestID) { success in
                    if success {
                        print("success")
                        if let onUpdate = self.onUpdate {
                           onUpdate()
                        }
                    } else {
                        print("failure")
                    }
                }
            }) {
                Text("Update")
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color.green)
            .cornerRadius(10)
            
            Button(action: {
                if let cancelAction = self.cancelAction {
                    cancelAction()
                }
            }) {
                Text("Cancel")
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color.red)
            .cornerRadius(10)
        }
    }
    
    private var placeHoderSection: some View {
        VStack {
            Spacer()
            Image(uiImage: UIImage(named: "pendingVerify-img")!)
                .resizable()
                .padding(.horizontal, 20)
            Text("Only pending requests can be edited..🙁")
                .foregroundColor(Color.black)
                .font(.system(size: 22, weight: .medium))
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
    
    
    private func dismissAlert() {
        withAnimation {
            isPresented = false
        }
    }
}
