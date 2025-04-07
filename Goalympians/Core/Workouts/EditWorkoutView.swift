//
//  WorkoutView.swift
//  AppDataTest
//
//  Created by Bernard Scott on 3/4/25.
//

import SwiftUI
import SwiftData

struct EditWorkoutView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var resistanceSets: [ResistanceSet]
    @Query private var runSets: [RunSet]
    @Query private var swimSets: [SwimSet]
    
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var workout: Workout
    var workoutId: String
    var userId: String
    
    var body: some View {
        VStack{
            Form {
                TextField("name", text: $workout.name)
                TextField("desc", text: $workout.desc, axis: .vertical)
                DatePicker("date", selection: $workout.date)

                Section("Exercises") {
                    ActivityView(workoutId: workoutId)
                }
            }
        }
        .navigationTitle("Edit Workout")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            NavigationLink("Add Exercise") {
                ExercisesView(workoutId: workoutId)
            }
        }
        
        Button("Save Changes") {
            Task {
                try await WorkoutManager.shared.updateWorkout(workout: DBWorkout(id: workoutId, userId: userId, name: workout.name, description: workout.desc, date: workout.date))
                //// I think this is fine because it's not forcing the main thread to wait, and instead will be called when
                //// the WorkoutManager is finished updating the workout
                dismiss()
            }
        }
    }
}

struct BoundsPreferenceKey: PreferenceKey {
    static var defaultValue: [Anchor<CGRect>] = [] // << use something persistent

    static func reduce(value: inout [Anchor<CGRect>], nextValue: () -> [Anchor<CGRect>]) {
        value.append(contentsOf:nextValue())
    }
}

#Preview {
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        let container = try ModelContainer(for: Workout.self, configurations: config)
//        let workout = Workout(name: "Example Workout", date: Date.now, desc: "This is a sample workout", intensity: 2, exercises: [])
////        let workout = DBWorkout(id: UUID().uuidString, userId: "Example_UID", name: "", description: "", date: Date.now)
//        return EditWorkoutView(workout: workout, workoutId: "SampleID", userId: "SampleUID")
//            .modelContainer(container)
//    } catch {
//        return Text("Failed to create container: \(error.localizedDescription)")
//    }
    NavigationStack {
        EditWorkoutView(workout: Workout(name: "Example Workout", date: Date.now, desc: "This is a sample workout", intensity: 2, exercises: []), workoutId: "SampleId", userId: "SampleUid")
    }
}
