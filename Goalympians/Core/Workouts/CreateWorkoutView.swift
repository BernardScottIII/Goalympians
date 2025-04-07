//
//  CreateWorkoutView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/6/25.
//

import SwiftUI

struct CreateWorkoutView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var date: Date = Date.now
    
    var body: some View {
        Form {
            TextField("Workout Name", text: $name)
            TextField("Workout Description", text: $description)
            DatePicker("Date", selection: $date)
        }
        .navigationTitle("Create Workout")
        Button("Create Workout") {
            Task {
                try await WorkoutManager.shared.createNewWorkout(workout: DBWorkout(
                    id: UUID().uuidString,
                    userId: AuthenticationManager.shared.getAuthenticatedUser().uid,
                    name: name,
                    description: description,
                    date: date
                ))
            }
            dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        CreateWorkoutView()
    }
}
