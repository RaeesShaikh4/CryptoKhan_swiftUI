//////  HelpListCardView.swift
////  Crypto_SwiftUI
//import SwiftUI
//import Firebase
//
//struct HelpListCardView: View {
//    var helpRequest: HelpListModel
//
//    var body: some View {
//        VStack(spacing: 8) {
//
//            HStack(alignment: .top) {
//
//                if let imageData = helpRequest.imageData, let uiImage = UIImage(data: imageData) {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 60, height: 60)
//                        .clipShape(Circle())
//                } else {
//                    Image(systemName: "photo.on.rectangle.angled")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 60, height: 60)
//                        .clipShape(Circle())
//                        .scaleEffect(0.7) // Adjust the scale factor as needed
//                }
//
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("\(helpRequest.title)")
//                        .foregroundColor(Color.theme.accent)
//                        .font(.headline)
//                        .lineLimit(2)
//
//                    HStack {
//                        Text("\(helpRequest.description)")
//                            .font(.body)
//                            .foregroundColor(Color.theme.accent)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                    }
//
//                    if let timestamp = helpRequest.timestamp {
//                        Text("\(formattedTimestamp(timestamp))")
//                            .font(.caption)
//                            .foregroundColor(Color.theme.accent)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                    }
//                }
//
//                Spacer()
//
//                statusButton(statusText: helpRequest.status)
//            }
//        }
//        .padding()
//        .background(Color.theme.background)
//        .cornerRadius(10)
//        .shadow(color: Color.theme.accent.opacity(0.25),
//            radius: 5,x: 0,y: 0)
//    }
//
//    private func formattedTimestamp(_ timestamp: Timestamp) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
//        return dateFormatter.string(from: timestamp.dateValue())
//    }
//
//    private func statusButton(statusText: String) -> some View {
//        let dotSize: CGFloat = 15
//        let color: Color
//
//        switch statusText.lowercased() {
//        case "pending":
//            color = .yellow
//        case "received":
//            color = .blue
//        case "inprogress":
//            color = .purple
//        case "resolved":
//            color = .green
//        case "closed":
//            color = .gray
//        default:
//            color = .black
//        }
//
//        return Circle()
//            .frame(width: dotSize, height: dotSize)
//            .foregroundColor(color)
//    }
//}
//


//MARK: above all good below for swipe to delete
import SwiftUI
import Firebase

struct HelpListCardView: View {
    var helpRequest: HelpListModel
    @ObservedObject var viewModel: HelpListViewModel
    @State private var offset: CGSize = .zero
    @State private var isDeleting: Bool = false
    
    var body: some View {
        VStack(spacing: 8) {
            
            HStack(alignment: .top) {
                
                if let imageData = helpRequest.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "photo.on.rectangle.angled")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .scaleEffect(0.6) // Adjust the scale factor as needed
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(helpRequest.title)")
                        .foregroundColor(Color.theme.accent)
                        .font(.headline)
                        .lineLimit(2)
                    
                    HStack {
                        Text("\(helpRequest.description)")
                            .font(.body)
                            .foregroundColor(Color.theme.accent)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    if let timestamp = helpRequest.timestamp {
                        Text("\(formattedTimestamp(timestamp))")
                            .font(.caption)
                            .foregroundColor(Color.theme.accent)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                Spacer()
                
                statusButton(statusText: helpRequest.status)
            }
            
        }
        .padding()
        .background(Color.theme.background)
        .cornerRadius(10)
        .shadow(color: Color.theme.accent.opacity(0.25),
                radius: 5,x: 0,y: 0)
        .offset(x: offset.width, y: 0)
        .gesture(
            DragGesture()
                .onChanged { value in
                    withAnimation {
                        offset.width = value.translation.width
                    }
                }
                .onEnded { value in
                    withAnimation {
                        if offset.width < -100 {
                            // Swipe to the left: Delete the document and related data
                            viewModel.deleteDocument(helpRequest)
                            isDeleting = true
                        } else {
                            // Swipe to the right or not enough swipe: Cancel deletion
                            offset = .zero
                            isDeleting = false
                        }
                    }
                }
        )
        .animation(.default, value: offset)
        .allowsHitTesting(!isDeleting) // Disable interaction when deleting
        .onDisappear {
            // Reset offset and isDeleting when the card disappears (e.g., after deletion)
            offset = .zero
            isDeleting = false
        }
    }
    
    private func formattedTimestamp(_ timestamp: Timestamp) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        return dateFormatter.string(from: timestamp.dateValue())
    }
    
    private func statusButton(statusText: String) -> some View {
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

