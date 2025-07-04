//
//  InternalVariableView.swift
//  Golympian
//
//  Created by Bernard Scott on 7/3/25.
//

import SwiftUI
import FirebaseFirestore

struct InternalVariableView: View {
    
    @StateObject private var workoutViewModel: WorkoutViewModel
    @StateObject private var exercisesViewModel: ExercisesViewModel
    @StateObject private var activityViewModel: ActivityViewModel
    @StateObject private var insightsViewModel: InsightsViewModel
    @StateObject private var settingsViewModel: SettingsViewModel
    @StateObject private var profileViewModel: ProfileViewModel
    @StateObject private var authenticationViewModel: AuthenticationViewModel
    
    @State private var removeWorkoutField: String
    @State private var userExercisesList: [APIExercise]
    @State private var globalExerciseList: [APIExercise]
//    @State private var activitiesList: [DBActivity]
    
    let dataService: WorkoutManagerProtocol
    
    init(dataService: WorkoutManagerProtocol) {
        self.dataService = dataService
        _workoutViewModel = StateObject(wrappedValue: WorkoutViewModel(workoutDataService: dataService))
        _exercisesViewModel = StateObject(wrappedValue: ExercisesViewModel(dataService: dataService))
        _activityViewModel = StateObject(wrappedValue: ActivityViewModel(dataService: dataService))
        _insightsViewModel = StateObject(wrappedValue: InsightsViewModel())
        _settingsViewModel = StateObject(wrappedValue: SettingsViewModel(workoutDataService: dataService))
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel())
        _authenticationViewModel = StateObject(wrappedValue: AuthenticationViewModel())
        
        self.removeWorkoutField = ""
        self.userExercisesList = []
        self.globalExerciseList = []
//        self.activitiesList = []
    }
    
    var body: some View {
        List {
            // MARK: Profile
            Section {
                HStack {
                    Text("Profile")
                        .font(.title)
                    Spacer()
                }
                
                Text(profileViewModel.user?.userId ?? "Cannot find user ID")
            }
            
            // MARK: Workouts
            Section {
                HStack {
                    Text("Workouts")
                        .font(.title)
                    Spacer()
                }
                ForEach(workoutViewModel.workouts, id: \.self) { workout in
                    Text(workout.name)
                    Text(workout.id)
                        .textSelection(.enabled)
                    Text("\(workout.date)")
                    Text(workout.description)
                }
                
                TextField("Remove workout ID", text: $removeWorkoutField)
                    .padding()
                    .background(Color(red: 1, green: (107/255), blue: (107/255)))
                
                Button("Remove Workout", role: .destructive, action: removeWorkout)
            }
            
            // MARK: Exercises
            Section {
                HStack {
                    Text("User Created Exercises")
                        .font(.title)
                    Spacer()
                }
                
                ForEach(userExercisesList, id: \.id) { exercise in
                    Text(exercise.id!)
                    NavigationLink(exercise.name, value: exercise)
                }
                Text("Global Exercises")
                    .font(.title)
                ForEach(globalExerciseList, id: \.id) { exercise in
                    Text(exercise.id!)
                    NavigationLink(exercise.name, value: exercise)
                }
            }
            
            // MARK: Activities
            Section {
                HStack {
                    Text("Activities")
                        .font(.title)
                    Spacer()
                }
                
                ForEach(workoutViewModel.workouts) { workout in
                    DeveloperActivityView(dataService: dataService, workoutId: workout.id)
                }
            }
            
            // MARK: Insights
            Section {
                HStack {
                    Text("Insights")
                        .font(.title)
                    Spacer()
                }
                
                ForEach(insightsViewModel.workoutInsight.properties, id: \.key) { property in
                    Text("\(property.key): \(property.value)")
                }
            }
        }
        .navigationTitle("Debug View")
        .navigationDestination(for: APIExercise.self) { exercise in
            ExerciseDetailsView(exercise: exercise)
        }
        .onAppear {
            Task {
                try await workoutViewModel.getAllWorkouts()
                try await profileViewModel.loadCurrentUser()
                try await exercisesViewModel.userIdsSelected(userIds: ["global", AuthenticationManager.shared.getAuthenticatedUser().uid])
                try await exercisesViewModel.getExercises()
                userExercisesList = []
                globalExerciseList = []
                for exercise in exercisesViewModel.exercises {
                    if exercise.uuid == "global" {
                        globalExerciseList.append(exercise)
                    } else {
                        userExercisesList.append(exercise)
                    }
                }
                try await insightsViewModel.getInsights()
            }
        }
    }
    
    private func removeWorkout() {
        Task {
            try await workoutViewModel.removeWorkout(workoutId: removeWorkoutField)
            removeWorkoutField = ""
            try await workoutViewModel.getAllWorkouts()
        }
    }
}

#Preview {
    NavigationStack {
        InternalVariableView(dataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts")))
    }
}
