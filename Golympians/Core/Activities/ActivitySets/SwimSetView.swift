//
//  SwimSetView.swift
//  Golympians
//
//  Created by Bernard Scott on 7/16/25.
//

import SwiftUI

struct SwimSetView: View {
    @Binding var distance: String
    @Binding var duration: String
    @Binding var laps: String
    
    var body: some View {
        HStack {
            
            Image(systemName: "point.bottomleft.forward.to.arrow.triangle.scurvepath.fill")
            TextField("distance", text: $distance)
                .keyboardType(.decimalPad)
            
            Image(systemName: "point.forward.to.point.capsulepath",)
            TextField("laps", text: $laps)
                .keyboardType(.numberPad)
            
            Image(systemName: "stopwatch.fill")
            TextField("duration", text: $duration)
                .keyboardType(.decimalPad)
            
        }
    }
}

#Preview {
    @Previewable @State var distance: String = ""
    @Previewable @State var duration: String = ""
    @Previewable @State var laps: String = ""
    List {
        SwimSetView(distance: $distance, duration: $duration, laps: $laps)
    }
}
