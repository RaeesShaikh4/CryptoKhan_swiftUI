import SwiftUI
import Firebase

struct HelpDetailView: View {
    
    var helpRequest: HelpListModel
    @State private var isVStackVisible: Bool = true
    @State private var currentValue: CGFloat = 0
    @State private var lastValue: CGFloat = 0
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom){
                Image(uiImage: UIImage(data: helpRequest.imageData ?? Data()) ?? UIImage(named: "markWithMan")!)
                    .resizable()
                    .aspectRatio(geometry.size ,contentMode: .fit)
                    .cornerRadius(10)
                    .scaleEffect(1 + currentValue + lastValue)
                    .offset(dragOffset)
                    .onTapGesture {
                        withAnimation {
                            isVStackVisible.toggle()
                        }
                    }
                    .gesture(
                        MagnificationGesture()
                            .onChanged({ value in
                                currentValue = value - 1
                            })
                            .onEnded({ value in
                                lastValue += currentValue
                                currentValue = 0
                            })
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation
                            }
                            .onEnded { _ in
                                dragOffset = .zero
                            }
                    )
                
                VStack(spacing: 30){
            
                    Text(helpRequest.title)
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.theme.accent)
                    
                    Text(helpRequest.description)
                        .font(.body)
                        .foregroundColor(Color.theme.accent)
                        .padding(.top, 10)
                    
                    HStack(spacing: 50){
                        Text(helpRequest.status)
                            .font(.subheadline)
                            .foregroundColor(Color.theme.accent)
                        
                        Spacer()
                        
                        if let formattedTimestamp = formattedTimestamp(helpRequest.timestamp) {
                            Text(formattedTimestamp)
                                .font(.subheadline)
                                .foregroundColor(Color.theme.accent)
                        }
                    }
                    .padding(.top, 20)
                }
                .padding(20)
                .background(Color.theme.background)
                .offset(y: isVStackVisible ? 0 : helpRequest.imageData != nil ? UIScreen.main.bounds.height : 0)
                .animation(.easeInOut)
                .shadow(color: Color.theme.accent.opacity(0.25),
                        radius: 10,x: 0,y: 0)
                
            }
            
        }
    }
}


extension HelpDetailView {
    func formattedTimestamp(_ timestamp: Timestamp?) -> String? {
        guard let timestamp = timestamp else { return nil }
        
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

