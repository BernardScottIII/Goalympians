//
//  ActivityListView.swift
//  AppDataTest
//
//  Created by Bernard Scott on 3/4/25.
//

import SwiftUI

struct ResistanceSetView: View {
    
    let resistanceSet: DBResistanceSet
    
    @State private var weight: Double? = nil
    @State private var repetitions: Int? = nil
    
    var body: some View {
        Text(resistanceSet.id)
        HStack {
            RealTimeNumericTextField(titleKey: "Weight", value: $weight, format: .number)
//            TextField("Weight", value: $weight, format: .number)
            Spacer()
            RealTimeNumericTextField(titleKey: "Repetitions", value: $repetitions, format: .number)
//            TextField("Repetitions", value: $repetitions, format: .number)
        }
    }
}

#Preview {
    NavigationStack {
        Form {
            ResistanceSetView(resistanceSet: DBResistanceSet(id: "12455", weight: 100.0, repetitions: 5))
        }
    }
}
