// AlertWithButton.swift
// Crypto_SwiftUI

import SwiftUI

struct AlertWithButton: View {
    
    enum AlertType {
        case success, failure
    }
    var type: AlertType
    var message: String
    var deleteAction: (() -> Void)?
    var closeAction: (() -> Void)?
    
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
                        
                        HStack(spacing: 16) {
                            Button(action: {
                                if let deleteAction = self.deleteAction {
                                    deleteAction()
                                }
                            }) {
                                Text("Delete")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color.red)
                            .cornerRadius(10)
                            
                            Button(action: {
                                if let closeAction = self.closeAction {
                                    closeAction()
                                }
                            }) {
                                Text("Close")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.theme.accent.opacity(0.25),
                                    radius: 6,x: 0,y: 0)
                        
                    )
                }
                .frame(width: min(geometry.size.width - 40, 270), height: 270)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2 - 50)
                .background(Color.clear)
                Spacer()
            }
            .background(Color.clear)
        }
        .background(Color.clear)
    }
}
