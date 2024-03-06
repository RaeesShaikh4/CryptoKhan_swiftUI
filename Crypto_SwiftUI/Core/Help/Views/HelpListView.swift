
import SwiftUI

struct HelpListView: View {
    @ObservedObject var viewModel = HelpListViewModel()
    @State private var isDetailViewActive: Bool = false
    @State private var selectedHelpRequest: HelpListModel?
    @State private var selectedStatus: String = "All Status"
    @State private var isDropdownOpen: Bool = false
    @State private var isCardTapped: Bool = false
    // for alert
    @State private var isAlertPresented: Bool = false
    @State private var selectedAlertHelpRequestID: String?
    @State private var selectedEditHelpRequestID: String?
    @State private var alertType: AlertWithButton.AlertType = .failure
    
    // for update view
    @State private var isEditHelpRequestPresented: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
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
                                .font(.system(size: 24, weight: .bold))
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List(filteredHelpList) { helpRequest in
                            HelpListCardView(helpRequest: helpRequest, viewModel: viewModel, isAlertPresented: $isAlertPresented, isEditHelpRequestPresented: $isEditHelpRequestPresented , onDelete: {
                                selectedAlertHelpRequestID = helpRequest.id
                                isAlertPresented = true
                            }, onUpdate: {
                                selectedEditHelpRequestID = helpRequest.id
                            }
                            )
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
                        .onChange(of: isCardTapped) { newValue in
                            isCardTapped = false
                        }
                        
                    }
                }
                .background(Color.clear)
                
                if isAlertPresented && selectedAlertHelpRequestID != nil {
                    alertSection
                        .background(Color.clear)
                }
                
                // Edit View Present
                if isEditHelpRequestPresented {
                    editSection
                        .frame(width: min(geometry.size.width - 40, 300), height: 300)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        .background(Color.clear)
                        .shadow(color: Color.theme.accent.opacity(0.25),
                                radius: 10, x: 0, y: 0)
                }
            }
        }
        .navigationTitle("Help Requests")
        .navigationBarItems(trailing:
                                NavigationLink(destination: HelpView()) {
            Image(systemName: "square.and.pencil")
                .foregroundColor(Color.theme.accent)
        }
        )
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
                }
                .background(Color.theme.background)
                .cornerRadius(10)
                .shadow(color: Color.theme.accent.opacity(0.25),
                        radius: 10,x: 0,y: 0)
            }
        }
        .accentColor(Color.theme.accent)
    }
    
    private var alertSection: some View {
        AlertWithButton(type: alertType, message: "Are you sure you want to delete?", deleteAction: {
            if let selectedAlertHelpRequestID = selectedAlertHelpRequestID {
                if viewModel.helpList.count > 0 {
                    for i in 0 ... viewModel.helpList.count - 1 {
                        if viewModel.helpList[i].id == selectedAlertHelpRequestID {
                            viewModel.removeDocument(helpRequest: self.viewModel.helpList[i],ID: self.viewModel.helpListID[i])
                        }
                    }
                }
            }
            isAlertPresented = false
        }, closeAction: {
            print("closeAction clicked on alert---")
            isAlertPresented = false
        })
        .background(Color.clear)
    }
    
    private var editSection: some View {
        if let selectedEditHelpRequestID = selectedEditHelpRequestID {
            print("selectedEditHelpRequestID---\(selectedEditHelpRequestID)")
            
            if let selectedHelpRequestIndex = viewModel.helpList.firstIndex(where: { $0.id == selectedEditHelpRequestID }) {
                print("selectedHelpRequestIndex---\(selectedHelpRequestIndex)")
                
                let selectedHelpRequest = viewModel.helpList[selectedHelpRequestIndex]
                    print("selectedHelpRequest --- \(selectedHelpRequest)")
                                
                return AnyView(
                    EditHelpRequest(
                        editRequestID: viewModel.helpListID[selectedHelpRequestIndex],
                        helpRequest: selectedHelpRequest,
                        cancelAction: {
                            isEditHelpRequestPresented = false
                        }, onUpdate: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                isEditHelpRequestPresented = false
                            }

                        }
                    )
                )
            }
        }
        return AnyView(Text("No help request selected"))
    }

}
