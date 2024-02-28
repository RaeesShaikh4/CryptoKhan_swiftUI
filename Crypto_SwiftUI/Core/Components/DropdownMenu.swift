//  DropdownMenu.swift
//  Crypto_SwiftUI

import SwiftUI
struct DropdownMenu: View {
    @Binding var selectedStatus: String
    @Binding var isDropdownOpen: Bool

    var body: some View {
        ZStack {
            VStack {
                Button {
                    isDropdownOpen.toggle()
                } label: {
                    HStack {
                        Text(selectedStatus)
                            .foregroundColor(Color.theme.accent)
                        Image(systemName: isDropdownOpen ? "chevron.up" : "chevron.down")
                    }
                }
                .padding(.horizontal, 10)
                .foregroundColor(Color.theme.accent)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.theme.background)
                        .shadow(color: Color.theme.accent.opacity(0.25), radius: 5, x: 0, y: 0)
                )
            }

            if isDropdownOpen {
                VStack {
                    ForEach(["All Status", "Pending", "Received", "In Progress", "Resolved", "Closed"], id: \.self) { status in
                        Button {
                            selectedStatus = status
                            isDropdownOpen.toggle()
                        } label: {
                            HStack {
                                StatusButton.statusButton(statusText: status)
                                Text(status)
                                    .foregroundColor(Color.theme.accent)
                            }
                            .padding(.horizontal, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 20)
                .background(Color.theme.background) // Optional: Set background color for dropdown options
                .zIndex(1) // Ensure that dropdown options appear above other components
            }
        }
    }
}

struct DropdownMenu_Previews: PreviewProvider {
    static var previews: some View {
        DropdownMenu(selectedStatus: .constant("All Status"), isDropdownOpen: .constant(false))
    }
}
