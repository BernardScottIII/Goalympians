//
//  RunSetView.swift
//  Golympians
//
//  Created by Bernard Scott on 7/16/25.
//

import SwiftUI

struct RunSetView: View {
    @Binding var distance: String
    @Binding var duration: String
    @Binding var elevation: String
    
    var body: some View {
        HStack {
            
            Image(systemName: "point.bottomleft.forward.to.arrow.triangle.scurvepath.fill")
            TextField("distance", text: $distance)
                .keyboardType(.decimalPad)
            
            Image(systemName: "barometer",)
            TextField("elevation", text: $elevation)
                .keyboardType(.decimalPad)
            
            Image(systemName: "stopwatch.fill")
            TextField("duration", text: $duration)
                .keyboardType(.decimalPad)
            
        }
    }
}

#Preview {
    @Previewable @State var distance: String = ""
    @Previewable @State var duration: String = ""
    @Previewable @State var elevation: String = ""
    List {
        RunSetView(distance: $distance, duration: $duration, elevation: $elevation)
    }
}
