//
//  CreateWorkoutView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/6/25.
//

import SwiftUI
import FirebaseFirestore

struct CreateWorkoutView: View {
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var date: Date = Date.now
    @State private var missingNameAlert: Bool = false
    @FocusState private var keyboardFocused: Bool
    private let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 1970, month: 1, day: 1)
        return calendar.date(from:startComponents)! ... Date(timeIntervalSinceNow: 0)
    }()
    
    @ObservedObject var viewModel: WorkoutViewModel
    @Binding var path: NavigationPath
    @Binding var isPresented: Bool
    
    init(
        viewModel: WorkoutViewModel,
        path: Binding<NavigationPath>,
        isPresented: Binding<Bool>
    ) {
        self.viewModel = viewModel
        _path = path
        _isPresented = isPresented
    }
    
    var body: some View {
        Form {
            TextField("Workout Name", text: $name)
                .focused($keyboardFocused)
                .textInputAutocapitalization(.words)
            
            TextField("Workout Description", text: $description)
                .textInputAutocapitalization(.sentences)
            
            DatePicker("Date", selection: $date, in: dateRange)
        }
        .navigationTitle("Create Workout")
        .onAppear {
            keyboardFocused = true
        }
        .alert("Error Creating New Workout", isPresented: $missingNameAlert) {
            Button("Okay", role: .cancel, action: {})
        } message: {
            Text("New workouts must be created with a name. Please enter a name for this workout.")
        }
        
        BottomActionButton(label: "Create New Workout", action: createWorkout)
    }
    
    private func createWorkout() {
        missingNameAlert = name == ""
        
        if !missingNameAlert {
            Task {
                path.append(try await viewModel.createWorkout(name: name, description: description, date: date))
                isPresented = false
            }
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    @Previewable @StateObject var viewModel = WorkoutViewModel(workoutDataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts")))
    NavigationStack {
        CreateWorkoutView(viewModel: viewModel, path: $path, isPresented: .constant(true))
    }
}
