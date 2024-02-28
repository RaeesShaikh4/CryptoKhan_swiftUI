//
//  SearchBarView.swift
//  Crypto_SwiftUI
//
//  Created by Vishal on 07/02/24.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    // color change on type
                    searchText.isEmpty ? Color.theme.secondaryText : Color.theme.accent
                )
            TextField("Search By Name or Symbol...",text: $searchText)
                .foregroundColor(Color.theme.accent)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundColor(Color.theme.accent)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            searchText = ""
                        }
                    
                    ,alignment: .trailing
                )
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(color: Color.theme.accent.opacity(0.20),
                        radius: 10,x: 0 ,y: 0)
        )
        .padding()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            SearchBarView(searchText: .constant(""))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)

            SearchBarView(searchText: .constant(""))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
      
    }
}
