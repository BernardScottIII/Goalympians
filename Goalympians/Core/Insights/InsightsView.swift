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
    @Published private(set) var exercises: [APIExercise] = []
    @Published private(set) var insights: [DBWorkout] = []
    
    func getInsights() {
        Task {
            self.exercises = try await ExerciseManager.shared.getAllExercises(nameDescending: nil, forCategory: nil)
        }
    }
    
    func addUserInsight(exerciseId: String) {
        Task {
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            try? await UserManager.shared.addUserInsight(userId: authDataResult.uid, exerciseName: exerciseId)
        }
    }
}

struct HKInsight {
    let id: Int
    let title: String
    let subtitle: String
    let image: String
    let amount: String
}

struct InsightsView: View {
    var activityViewModel: ActivityViewModel
    
    @State private var currentInsight: String?
    @EnvironmentObject private var healthManager: HealthManager
    
    private var selectedInsight: ActivityInsight? {
        guard let currentInsight else { return nil }
        return ActivityInsight.mockData.first {
            currentInsight == $0.exerciseName
        }
    }
    
    @StateObject private var viewModel = InsightsViewModel()
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)){
                ForEach(healthManager.hkInsights.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { insight in
                    HKInsightCard(hkInsight: insight.value)
                }
            }
            .padding(.horizontal)
            Chart {
                ForEach(ActivityInsight.mockData, id: \.id) { insight in
                    BarMark(
                        x: .value("Total Number of Repetitions", insight.totalRepetitionsRecorded),
                        y: .value("Exercise Name", insight.exerciseName)
                    )
                    .foregroundStyle(
                        by: .value("Exercise Type", insight.setType.rawValue)
                    )
                    .opacity(currentInsight == nil || insight.id == selectedInsight?.id ? 1.0 : 0.3)
                }
                if let selectedInsight {
                    RuleMark(
                        xStart: .value("Total Number of Repetitions", selectedInsight.totalRepetitionsRecorded),
                        xEnd: .value("Max Number of Repetitions", 150),
                        y: .value("Exercise Name", selectedInsight.exerciseName)
                    )
                    .foregroundStyle(.secondary.opacity(0.3))
                    .annotation(position: .overlay, overflowResolution: .init(x: .fit(to: .chart), y: .fit(to: .chart))) {
                        VStack {
                            Text(selectedInsight.exerciseName)
                            Text("\(selectedInsight.totalRepetitionsRecorded)")
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
            healthManager.fetchTodaySteps()
            healthManager.fetchTodayCalories()
        }
    }
}

struct ActivityInsight: Identifiable {
    let id = UUID()
    let userId: String
    let exerciseName: String
    let usedInWorkouts: Int
    let totalRepetitionsRecorded: Int
    let setType: SetType
    
    static let mockData: [ActivityInsight] = [
        .init(userId: "GzP3A2DuGXcurrH1GrIl0ghqYPe2", exerciseName: "Sample Exercise 1", usedInWorkouts: 6, totalRepetitionsRecorded: 32, setType: .resistanceSet),
        .init(userId: "GzP3A2DuGXcurrH1GrIl0ghqYPe2", exerciseName: "Sample Exercise 2", usedInWorkouts: 8, totalRepetitionsRecorded: 64, setType: .runSet),
        .init(userId: "GzP3A2DuGXcurrH1GrIl0ghqYPe2", exerciseName: "Sample Exercise 3", usedInWorkouts: 5, totalRepetitionsRecorded: 35, setType: .swimSet),
        .init(userId: "GzP3A2DuGXcurrH1GrIl0ghqYPe2", exerciseName: "Sample Exercise 4", usedInWorkouts: 3, totalRepetitionsRecorded: 12, setType: .resistanceSet),
        .init(userId: "GzP3A2DuGXcurrH1GrIl0ghqYPe2", exerciseName: "Sample Exercise 5", usedInWorkouts: 4, totalRepetitionsRecorded: 32, setType: .swimSet),
        .init(userId: "GzP3A2DuGXcurrH1GrIl0ghqYPe2", exerciseName: "Sample Exercise 6", usedInWorkouts: 10, totalRepetitionsRecorded: 120, setType: .runSet),
    ]
}

#Preview {
    @Previewable @StateObject var healthManager = HealthManager()
    NavigationStack {
        InsightsView(activityViewModel: ActivityViewModel(dataService: ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts"))))
            .environmentObject(healthManager)
    }
}

