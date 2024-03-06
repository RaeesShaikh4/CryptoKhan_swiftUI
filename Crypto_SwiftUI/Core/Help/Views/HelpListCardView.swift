import SwiftUI
import Firebase

struct HelpListCardView: View {
    var helpRequest: HelpListModel
    @ObservedObject var viewModel: HelpListViewModel
    @State private var offset: CGSize = .zero
    @State private var isDeleting: Bool = false
    @State private var alertType: AlertWithButton.AlertType = .failure
    
    @Binding var isAlertPresented: Bool
    @State var selectedAlertHelpRequestID: String?
    
    @Binding var isEditHelpRequestPresented: Bool
    
    var onDelete: (() -> Void)?
    var onUpdate: (() -> Void)?
    
    var body: some View {
        ZStack {
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
                            .scaleEffect(0.6)
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
                        
                        
                        HStack {
                            
                            if let timestamp = helpRequest.timestamp {
                                Text("\(formattedTimestamp(timestamp))")
                                    .font(.subheadline)
                                    .foregroundColor(Color.theme.accent)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "square.and.pencil.circle")
                                .resizable()
                                .frame(width: 30,height: 30,alignment: .trailing)
                                .fontWeight(.light)
                                .foregroundColor(Color.theme.accent)
                                .onTapGesture {
                                    onUpdate?()
                                    isEditHelpRequestPresented = true
                                }
                               
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
                            offset.width = min(max(value.translation.width, -100), 0)
                            isDeleting = offset.width < -50
                        }
                    }
                    .onEnded { value in
                        withAnimation {
                            if isDeleting{
                                offset.width = -100
                            } else {
                                offset = .zero
                            }
                        }
                    }
            )
            .animation(.default, value: offset)
            .onDisappear {
                offset = .zero
                isDeleting = false
            }
            
            HStack {
                Spacer()
                Image(systemName: "trash")
                    .padding(20)
                    .background(Color.red)
                    .clipShape(Circle())
                    .foregroundColor(.white)
                    .opacity(isDeleting ? 1 : 0)
                    .onTapGesture {
                        print("onTapGesture called---")
                        onDelete?()
                    }
                    .onChange(of: isAlertPresented) { newValue in
                        if !newValue {
                            withAnimation {
                                offset = .zero
                                isDeleting = false
                            }
                        }
                    }
            }
            
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

