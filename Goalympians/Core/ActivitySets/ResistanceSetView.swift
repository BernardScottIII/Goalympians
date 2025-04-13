//
//  ActivityListView.swift
//  AppDataTest
//
//  Created by Bernard Scott on 3/4/25.
//

import SwiftUI

struct ResistanceSetView: View {
    
    let resistanceSet: DBActivitySet
    let workoutId: String
    let activity: DBActivity
    @Binding var refreshHelper: Int
    
    @State private var weight: Double? = nil
    @State private var repetitions: Int? = nil
    @FocusState private var weightFocused: Bool
    @FocusState private var repetitionsFocused: Bool
    @StateObject private var viewModel = ResistanceSetViewModel()
    
    var body: some View {
        HStack {
            TextField("Weight", value: $weight, format: .number)
                .focused($weightFocused)
                .onChange(of: weightFocused) { oldValue, newValue in
                    if newValue == false {
                        Task {
                            try await viewModel.updateActivitySet(workoutId: workoutId, activity: activity, set: DBResistanceSet(id: resistanceSet.id, weight: weight ?? 0.0, repetitions: repetitions ?? 0))
                        }
                    }
                }
                .onAppear {
                    Task {
                        let snapshot = try await viewModel.getSetMetrics(workoutId: workoutId, activity: activity, setId: resistanceSet.id)
                        weight = snapshot.weight
                        repetitions = snapshot.repetitions
                    }
                }
            Spacer()
            TextField("Repetitions", value: $repetitions, format: .number)
                .focused($repetitionsFocused)
                .onChange(of: repetitionsFocused) { oldValue, newValue in
                    if newValue == false {
                        Task {
                            try await viewModel.updateActivitySet(workoutId: workoutId, activity: activity, set: DBResistanceSet(id: resistanceSet.id, weight: weight ?? 0.0, repetitions: repetitions ?? 0))
                        }
                    }
                }
            Button("", systemImage: "trash") {
                Task {
                    try await viewModel.removeActivitySet(workoutId: workoutId, activityId: activity.id, setId: resistanceSet.id)
                    refreshHelper = UUID().hashValue
                }
            }
        }
    }
}

private func previewFunc() {}

#Preview {
    NavigationStack {
        Form {
            ResistanceSetView(resistanceSet: DBResistanceSet(id: "iP1wvEqnL3YdoTGDlvyv", weight: 0.0, repetitions: 0), workoutId: "49F6D3AB-C3A6-4B9C-84DF-ECF5E4ECEC3D", activity: DBActivity(id: "GzTwAOOgE40xBv6bFZ9Z", exerciseId: 6108960088522398000, setType: .resistanceSet), refreshHelper: .constant(0))
        }
    }
}
