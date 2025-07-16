//
//  ResistanceSetView.swift
//  Golympians
//
//  Created by Bernard Scott on 7/16/25.
//

import SwiftUI

struct ResistanceSetView: View {
    @Binding var weight: String
    @Binding var repetitions: String
    
    var body: some View {
        HStack {
            
            Image(systemName: "scalemass.fill")
            TextField("weight", text: $weight)
                .keyboardType(.decimalPad)
//                .focused
            
            Image(systemName: "checkmark.arrow.trianglehead.counterclockwise")
            TextField("repetitions", text: $repetitions)
                .keyboardType(.numberPad)
            
        }
    }
}

#Preview {
    @Previewable @State var weight: String = "11.5"
    @Previewable @State var repetitions: String = "5"
    List {
        ResistanceSetView(weight: $weight, repetitions: $repetitions)
    }
}
