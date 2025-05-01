//
//  InsightsView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/24/25.
//

import SwiftUI
import Charts
import FirebaseFirestore

final class InsightsViewModel: ObservableObject {
    @Published private(set) var insights: [DBWorkout] = []
    
    func getInsights() {
        
    }
}

struct InsightsView: View {
    var workoutViewModel: WorkoutViewModel
    var activityViewModel: ActivityViewModel
    
    @State private var currentInsight: String?
    
    private var selectedInsight: ActivityInsight? {
        guard let currentInsight else { return nil }
        return ActivityInsight.mockData.first {
            currentInsight == $0.exerciseName
        }
    }
    
    private let exerciseInsights: [ExerciseInsight] = [
        .init(userId: "GzP3A2DuGXcurrH1GrIl0ghqYPe2", exerciseName: "Sample Exercise 1", setType: .resistanceSet, repetitionCount: 152, weightTotal: 340, pr: 30),
        .init(userId: "GzP3A2DuGXcurrH1GrIl0ghqYPe2", exerciseName: "Sample Exercise 2", setType: .resistanceSet, repetitionCount: 84, weightTotal: 200, pr: 15),
        .init(userId: "GzP3A2DuGXcurrH1GrIl0ghqYPe2", exerciseName: "Sample Exercise 1", setType: .runSet, repetitionCount: 180, weightTotal: 1250, pr: 135),
        .init(userId: "GzP3A2DuGXcurrH1GrIl0ghqYPe2", exerciseName: "Sample Exercise 2", setType: .runSet, repetitionCount: 50, weightTotal: 180, pr: 135),
        .init(userId: "GzP3A2DuGXcurrH1GrIl0ghqYPe2", exerciseName: "Sample Exercise 1", setType: .swimSet, repetitionCount: 125, weightTotal: 1250, pr: 135),
        .init(userId: "GzP3A2DuGXcurrH1GrIl0ghqYPe2", exerciseName: "Sample Exercise 2", setType: .swimSet, repetitionCount: 100, weightTotal: 1250, pr: 135),
        .init(userId: "GzP3A2DuGXcurrH1GrIl0ghqYPe2", exerciseName: "Sample Exercise 3", setType: .resistanceSet, repetitionCount: 20, weightTotal: 500, pr: 85),
        .init(userId: "GzP3A2DuGXcurrH1GrIl0ghqYPe2", exerciseName: "Sample Exercise 3", setType: .runSet, repetitionCount: 160, weightTotal: 625, pr: 300),
        .init(userId: "GzP3A2DuGXcurrH1GrIl0ghqYPe2", exerciseName: "Sample Exercise 3", setType: .swimSet, repetitionCount: 60, weightTotal: 1250, pr: 185)
    ]
    
    @StateObject private var viewModel = InsightsViewModel()
    
    var body: some View {
        VStack {
            Chart {
                ForEach(ActivityInsight.mockData, id: \.id) { insight in
                    BarMark(
                        x: .value("Total Number of Sets", insight.totalSetsRecorded),
                        y: .value("Exercise Name", insight.exerciseName)
                    )
                    .foregroundStyle(
                        by: .value("Exercise Type", insight.setType.rawValue)
                    )
                    .opacity(currentInsight == nil || insight.id == selectedInsight?.id ? 1.0 : 0.3)
                }
                if let selectedInsight {
                    RuleMark(
                        xStart: .value("Total Number of Sets", selectedInsight.totalSetsRecorded),
                        xEnd: .value("Max Number of Sets", 150),
                        y: .value("Exercise Name", selectedInsight.exerciseName)
                    )
                    .foregroundStyle(.secondary.opacity(0.3))
                    .annotation(position: .overlay, overflowResolution: .init(x: .fit(to: .chart), y: .fit(to: .chart))) {
                        VStack {
                            Text(selectedInsight.exerciseName)
                            Text("\(selectedInsight.totalSetsRecorded)")
                        }
                        .foregroundStyle(.white)
                        .padding(12)
                        .frame(width: 120)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.purple.gradient))
                    }
                }
            }
            .frame(height: 480)
            .chartYSelection(value: $currentInsight.animation(.easeInOut))
//            .chartYScale(domain: 0...50)
            .chartXAxisLabel("Exercise Name")
            .chartYAxisLabel("Total Number of Repetitions")
            .chartForegroundStyleScale([
                SetType.resistanceSet.rawValue: .blue,
                SetType.runSet.rawValue: .red,
                SetType.swimSet.rawValue: .green
            ])
            .padding()
        }
        .navigationTitle("Insights Page")
        .onAppear {
            viewModel.getInsights()
        }
    }
}

struct WorkoutInsight: Identifiable {
    let id = UUID()
    let userId: String
    let workoutId: String
    let workoutDate: Date
    let totalSets: Int
    let totalExercises: Int
    let totalWeight: Double
    let totalRepetitions: Int
    let setCountBreakdown: [SetType:Int]
}

struct ExerciseInsight: Identifiable {
    let id = UUID()
    let userId: String
    let exerciseName: String // Date in the example
    let setType: SetType
    
//    let insightDetails: [insightDetailCategory:Any]
    
    // Cumulative total of repetitions recorded by this user across all workouts.
    let repetitionCount: Int
    
    // For every activitySet, append the repetitions * weight to this total
    // Example:
    // - set 1 [ 10 lbs for 10 reps]
    // - set 2 [ 15 lbs for 8 reps]
    // - set 3 [ 20 lbs for 6 reps]
    // total to append: (10*10) + (15*8) + (20*6) = 340lbs
    let weightTotal: Double
    
    // "pr" stands for personal record (also known as one-repetition maximum),
    // with a user's personal record being denoted by the maximum amount of
    // weight they can take on while still successfully completing one
    // repetition of the indicated exercise.
    let pr: Double
}

struct ActivityInsight: Identifiable {
    let id = UUID()
    let userId: String
    let exerciseName: String
    let usedInWorkouts: Int
    let totalSetsRecorded: Int
    let setType: SetType
    
    static let mockData: [ActivityInsight] = [
        .init(userId: "GzP3A2DuGXcurrH1GrIl0ghqYPe2", exerciseName: "Sample Exercise 1", usedInWorkouts: 6, totalSetsRecorded: 32, setType: .resistanceSet),
        .init(userId: "GzP3A2DuGXcurrH1GrIl0ghqYPe2", exerciseName: "Sample Exercise 2", usedInWorkouts: 8, totalSetsRecorded: 64, setType: .runSet),
        .init(userId: "GzP3A2DuGXcurrH1GrIl0ghqYPe2", exerciseName: "Sample Exercise 3", usedInWorkouts: 5, totalSetsRecorded: 35, setType: .swimSet),
        .init(userId: "GzP3A2DuGXcurrH1GrIl0ghqYPe2", exerciseName: "Sample Exercise 4", usedInWorkouts: 3, totalSetsRecorded: 12, setType: .resistanceSet),
        .init(userId: "GzP3A2DuGXcurrH1GrIl0ghqYPe2", exerciseName: "Sample Exercise 5", usedInWorkouts: 4, totalSetsRecorded: 32, setType: .swimSet),
        .init(userId: "GzP3A2DuGXcurrH1GrIl0ghqYPe2", exerciseName: "Sample Exercise 6", usedInWorkouts: 10, totalSetsRecorded: 120, setType: .runSet),
    ]
}

#Preview {
    NavigationStack {
        InsightsView(workoutViewModel: WorkoutViewModel(workoutDataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts"))), activityViewModel: ActivityViewModel(dataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts"))))
    }
}
