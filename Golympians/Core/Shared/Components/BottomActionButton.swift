//
//  BottomActionButton.swift
//  Golympian
//
//  Created by Bernard Scott on 6/9/25.
//

import SwiftUI

struct BottomActionButton: View {
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(label, action: action)
            .padding()
            .background(.golympiansPrimary)
            .clipShape(.buttonBorder)
            .foregroundStyle(.white)
            .fontWeight(.bold)
    }
}

#Preview {
    BottomActionButton(label: "My Custom Button", action: {})
}
