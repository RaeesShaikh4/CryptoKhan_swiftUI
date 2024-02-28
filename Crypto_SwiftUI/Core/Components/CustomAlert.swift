//MARK: Alert with buttons
//import SwiftUI
//
//struct CustomAlert: View {
//    enum AlertType {
//        case success, failure
//    }
//
//    var type: AlertType
//    var message: String
//    var action: (() -> Void)?
//
//    var body: some View {
//        GeometryReader { geometry in
//            VStack {
//                Spacer()
//                ZStack {
//                    VStack(spacing: 16) {
//                        Image(systemName: type == .success ? "checkmark.circle.fill" : "xmark.circle.fill")
//                            .font(.system(size: 40, weight: .bold))
////                            .foregroundColor(Color.theme.secondaryText)
//                            .foregroundColor(.black)
//                        Text(message)
//                            .font(.title3)
////                            .foregroundColor(Color.theme.secondaryText)
//                            .foregroundColor(.black)
//                            .multilineTextAlignment(.center)
//                            .padding(.horizontal)
//
//                        Button(action: {
//                            if let action = self.action {
//                                action()
//                            }
//                        }) {
//                            Text(type == .success ? "Dismiss" : "Okay")
//                        }
//
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding(.horizontal)
//                        .padding(.vertical, 10)
//                        .background(Color(type == .success ? UIColor.green : UIColor.red))
//                        .cornerRadius(10)
//                    }
//                    .padding()
//                    .background(
//                        RoundedRectangle(cornerRadius: 20)
//                            .fill(Color.white)
//                            .shadow(color: Color("lightShadow"), radius: 8, x: -8, y: -8)
//                            .shadow(color: Color("darkShadow"), radius: 8, x: 8, y: 8)
//                    )
//                }
//                .frame(width: min(geometry.size.width - 40, 270), height: 270)
//                .position(x: geometry.size.width / 2, y: geometry.size.height - 350) // for vertical position
//
//                Spacer()
//            }
//        }
//    }
//}

//MARK: Alert without buttons Auto Dissmissal
import SwiftUI

struct CustomAlert: View {
    enum AlertType {
        case success, failure
    }

    var type: AlertType
    var message: String
    var action: (() -> Void)?

    @State private var isPresented = true

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack {
                    VStack(spacing: 16) {
                        Image(systemName: type == .success ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.black)

                        Text(message)
                            .font(.title3)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        // No button in this version

                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color("lightShadow"), radius: 8, x: -8, y: -8)
                            .shadow(color: Color("darkShadow"), radius: 8, x: 8, y: 8)
                    )
                }
                .frame(width: min(geometry.size.width - 40, 270), height: 270)
                .position(x: geometry.size.width / 2, y: geometry.size.height - 350) // for vertical position
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        dismissAlert()
                    }
                }

                Spacer()
            }
            .opacity(isPresented ? 1 : 0)
        }
    }

    private func dismissAlert() {
        withAnimation {
            isPresented = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            action?()
        }
    }
}

