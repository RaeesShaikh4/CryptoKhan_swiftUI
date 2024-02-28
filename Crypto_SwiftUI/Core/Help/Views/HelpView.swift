////MARK: Firebase all good
//import SwiftUI
//
//struct HelpView: View {
//
//    @State private var request: String = ""
//    @State private var description: String = ""
//    @State private var isSending: Bool = false
//    @State private var descriptionHeight: CGFloat = 170
//    @State private var showAlert = false
//    @State private var alertType: CustomAlert.AlertType?
//
//    //ViewModel
//    @ObservedObject private var viewModel = HelpViewModel()
//
//    var body: some View {
//        ZStack {
//            VStack {
//                Image(systemName: "envelope.fill")
//                    .resizable()
//                    .frame(width: 70, height: 70)
//                    .scaledToFit()
//                    .foregroundColor(.blue)
//                    .padding(.top, 60)
//
//                Text("Need Help?")
//                    .font(.title)
//                    .fontWeight(.bold)
//                    .padding(.top, 5)
//
//                Text("Our support team is here to assist you.")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal, 20)
//                    .padding(.top, 5)
//
//                Spacer()
//
//                requestBodySection
//
//                requestButton()
//
//                Spacer()
//            }
//
//            if showAlert {
//                VStack {
//                    CustomAlert(type: alertType ?? .success, message: alertType == .success ? "Your request posted successfully..😀" : "Please fill the required Fields..😐") {
//                        showAlert = false
//                    }
//                }
//            }
//        }
//        .navigationBarTitle("Help Center", displayMode: .inline)
//        .padding()
//    }
//
//    private var requestBodySection: some View {
//        VStack(spacing: 20) {
//            TextField("Enter your request here...", text: $request)
//                .padding()
//                .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemGray6)))
//                .foregroundColor(Color.theme.accent)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.gray, lineWidth: 1)
//                )
//            TextEditor(text: $description)
//                .frame(height: descriptionHeight)
//                .colorMultiply(Color(UIColor.systemGray6))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.gray, lineWidth: 1)
//                )
//        }
//        .padding(.horizontal, 20)
//        .padding(.top, 10)
//    }
//
//    private func requestButton() -> some View {
//        Button(action: {
//            if request.isEmpty || description.isEmpty {
//                showAlert = true
//                alertType = .failure
//            } else {
//                print("requestButton saving data---")
//                viewModel.sendFeedback(title: request, description: description, status: .pending) { result in
//                    switch result {
//                    case .success:
//                        showAlert = true
//                        alertType = .success
//                        request = ""
//                        description = ""
//                    case .failure(let error):
//                        print("Error in request button: \(error)")
//                        showAlert = true
//                        alertType = .failure
//
//                    }
//                }
//            }
//        }) {
//            Text(viewModel.isSending ? "Sending..." : "Share Request")
//                .frame(maxWidth: .infinity)
//                .frame(height: 50)
//                .background(buttonColor)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//                .padding(.horizontal, 20)
//        }
//        .padding(.top, 10)
//    }
//
//
//    private var buttonColor: Color {
//        if viewModel.isSending {
//            return Color.green
//        } else if request.isEmpty || description.isEmpty {
//            return Color.gray
//        } else {
//            return Color.blue
//        }
//    }
//
//}
//
//struct HelpView_Previews: PreviewProvider {
//    static var previews: some View {
//        HelpView()
//    }
//}

//MARK: for image upload section lgic above all good
import SwiftUI

struct HelpView: View , ImagePickerDelegate{
     
    @State private var request: String = ""
    @State private var description: String = ""
    @State private var isSending: Bool = false
    @State private var descriptionHeight: CGFloat = 170
    @State private var showAlert = false
    @State private var alertType: CustomAlert.AlertType?
    // image
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented: Bool = false
    @State private var isImagePickerActive: Bool = false
    @State private var imageName: String?

    //ViewModel
    @ObservedObject private var viewModel = HelpViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "envelope.fill")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .scaledToFit()
                    .foregroundColor(.blue)
                    .padding(.top, 60)
                
                Text("Need Help?")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 5)
                
                Text("Our support team is here to assist you.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 5)
                
                Spacer()
                
                requestBodySection
                
                Spacer()
                
                NavigationLink(destination: ImagePicker(selectedImage: $selectedImage, isImagePickerPresented: $isImagePickerPresented, delegate: self), isActive: $isImagePickerPresented) {
                    EmptyView()
                }
                
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
                        .frame(width: 60, height: 60)
                        .animation(.none)
                        .onTapGesture {
                            isImagePickerPresented.toggle()
                            isImagePickerActive = true
                        }
                }
                .padding(.trailing, 16)


                requestButton()
                
                Spacer()
            }
            
            if showAlert {
                VStack {
                    CustomAlert(type: alertType ?? .success, message: alertType == .success ? "Your request posted successfully..😀" : "Please fill the required Fields..😐") {
                        showAlert = false
                    }
                }
            }
        }
        .navigationBarTitle("Help Center", displayMode: .inline)
        .padding()
    }
    
    private var requestBodySection: some View {
        VStack(spacing: 20) {
            TextField("Enter your request here...", text: $request)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemGray6)))
                .foregroundColor(Color.theme.accent)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
            TextEditor(text: $description)
                .frame(height: descriptionHeight)
                .colorMultiply(Color(UIColor.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private func requestButton() -> some View {
        Button(action: {
            if request.isEmpty || description.isEmpty {
                showAlert = true
                alertType = .failure
            } else {
                print("requestButton saving data---")
                viewModel.sendFeedback(title: request, description: description, image: selectedImage , status: .pending) { result in
                    switch result {
                    case .success:
                        showAlert = true
                        alertType = .success
                        request = ""
                        description = ""
                        selectedImage = nil
                    case .failure(let error):
                        print("Error in request button: \(error)")
                        showAlert = true
                        alertType = .failure
                        
                    }
                }
            }
        }) {
            Text(viewModel.isSending ? "Sending..." : "Share Request")
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(buttonColor)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal, 20)
        }
        .padding(.top, 10)
    }
    
    
    private var buttonColor: Color {
        if viewModel.isSending {
            return Color.green
        } else if request.isEmpty || description.isEmpty {
            return Color.gray
        } else {
            return Color.blue
        }
    }
    
    // ImagePickerDelegate method
    func didSelectImage(_ image: UIImage?, imageName: String?) {
        selectedImage = image
        self.imageName = imageName
    }
    
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}



