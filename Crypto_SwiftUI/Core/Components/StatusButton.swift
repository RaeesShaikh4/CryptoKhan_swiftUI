//  StatusButton.swift
//  Crypto_SwiftUI


import SwiftUI

struct StatusButton: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    static func statusButton(statusText: String) -> some View {
        let dotSize: CGFloat = 15
        let color: Color
        
        switch statusText.lowercased() {
        case "pending":
            color = .yellow
        case "received":
            color = .blue
        case "inprogress":
            color = .purple
        case "resolved":
            color = .green
        case "closed":
            color = .gray
        default:
            color = .black
        }
        
        return Circle()
            .frame(width: dotSize, height: dotSize)
            .foregroundColor(color)
    }
}

struct StatusButton_Previews: PreviewProvider {
    static var previews: some View {
        StatusButton()
    }
}
