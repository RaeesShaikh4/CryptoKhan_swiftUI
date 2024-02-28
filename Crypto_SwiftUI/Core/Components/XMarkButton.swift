//
//  XMarkButton.swift
//  Crypto_SwiftUI
//
//  Created by Vishal on 08/02/24.
//

import SwiftUI

struct XMarkButton: View {
    
    @Binding var isPresented: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button {
            isPresented = false
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
    }
}


struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        let isPresented = Binding.constant(false)
        return XMarkButton(isPresented: isPresented)
    }
}
