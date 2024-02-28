
import SwiftUI

struct HelpListView: View {
    @ObservedObject var viewModel = HelpListViewModel()
    @State private var isDetailViewActive: Bool = false
    @State private var selectedHelpRequest: HelpListModel?
    @State private var selectedStatus: String = "All Status"
    @State private var isDropdownOpen: Bool = false
    @State private var isCardTapped: Bool = false
    
    
    var body: some View {
        VStack {
            
            helpDropDown
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity, alignment: .trailing)
                .frame(height: 70)
                .clipped()
                .padding(.horizontal)
                .background(Color.clear)
                .onTapGesture {
                    isDropdownOpen.toggle()
                }
            
            let filteredHelpList = viewModel.helpList.filter {
                selectedStatus.lowercased() == "all status" || $0.status.lowercased() == selectedStatus.lowercased()
            }
            
            if filteredHelpList.isEmpty {
                VStack {
                    Spacer()
                    Image(uiImage: UIImage(named: "data-not-found")!)
                        .resizable()
                        .frame(width: 300, height: 300)
                        .clipShape(Circle())
                        .padding()
                    Text("Data not found...?")
                        .foregroundColor(Color.theme.accent)
                       
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(filteredHelpList) { helpRequest in
                    HelpListCardView(helpRequest: helpRequest, viewModel: viewModel)
                        .padding(.vertical, 8)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            if !isDropdownOpen {
                                isCardTapped = true
                                selectedHelpRequest = helpRequest
                                isDetailViewActive = true
                            }
                        }
                        .background(
                            NavigationLink(
                                destination: HelpDetailView(helpRequest: selectedHelpRequest ?? helpRequest),
                                isActive: $isDetailViewActive
                            ) {
                                EmptyView().hidden()
                            }
                        )
                }
                .background(
                    Color.black.opacity(isDropdownOpen ? 0.3 : 0)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            isDropdownOpen = false
                        }
                )
                .listStyle(.plain)
                .navigationTitle("Help Requests")
                .navigationBarItems(trailing:
                                        NavigationLink(destination: HelpView()) {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(Color.theme.accent)
                }
                )
                .onChange(of: isCardTapped) { newValue in
                    isCardTapped = false
                }
            }
            
        }
    }
    
    func statusButton(statusText: String) -> some View {
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

struct HelpListView_Previews: PreviewProvider {
    static var previews: some View {
        HelpListView()
    }
}

extension HelpListView {
    
    private var helpDropDown: some View {
        Picker(selection: $selectedStatus, label: Text("Select Status")) {
            ForEach(["All Status", "Pending", "Received", "In Progress", "Resolved", "Closed"], id: \.self) { status in
                HStack{
                    statusButton(statusText: status)
                        .frame(width: 20, height: 20)
                    Text(status)
                        .tag(status)
                        .foregroundColor(Color.theme.accent)
                }
                .background(Color.theme.background)
                .cornerRadius(10)
                .shadow(color: Color.theme.accent.opacity(0.25),
                        radius: 10,x: 0,y: 0)
            }
        }
    }
    
}
