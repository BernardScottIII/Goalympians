//
//  InsightsView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/24/25.
//

import SwiftUI
import Charts
import FirebaseFirestore

struct Insight: Identifiable, Codable {
    let id: String
    let name: String
    let data: [String:Double]
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case data
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.data, forKey: .data)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.data = try container.decode([String : Double].self, forKey: .data)
    }
    
    // form: [insight_name:data_dict]
    // Maybe have a exercise_insights subcollection?
    // Move everything up a level and have various <feature>_insights collections
    // exercise_insights, workout_insights,
    let defaultInsights = [
        "workout_count": ["count":0],
        "exercise_count": ["no_exercise":0]
    ]
}

struct HKInsight {
    let id: Int
    let title: String
    let subtitle: String
    let image: String
    let amount: String
}

struct InsightsView: View {
    
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
//            Button("Add new insight") {
//                viewModel.initUserNewInsight()
//            }
            
            InsightCardView(viewModel: viewModel)
            
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)){
                ForEach(healthManager.hkInsights.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { insight in
                    HKInsightCard(hkInsight: insight.value)
                }
            }
            .padding(.horizontal)
            
            InsightMetricView(viewModel: viewModel)
            
            // "It works"
            // We should set up a listener so it updates in real time and doesn't require refresh
            // Ooh I should also learn how to implement refreshes
            // We shouldn't use state because I'd need potentially infinite # of state vars
//            Text("List of insights")
//            ForEach(viewModel.insights) {insight in
//                Text("New insight:")
//                // Why force-unwrap? Trust me bro, the key is there.
//                Text("Number of workouts created: \(Int(insight.data["count"]!))")
//            }
        }
        .navigationTitle("Insights Page")
        .onAppear {
            healthManager.fetchTodaySteps()
            healthManager.fetchTodayCalories()
            Task {
                try await viewModel.getInsights()
            }
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
        InsightsView()
            .environmentObject(healthManager)
    }
}

