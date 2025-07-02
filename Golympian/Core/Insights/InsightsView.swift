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
    @StateObject private var viewModel = InsightsViewModel()
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false) {
//            Button("Add new insight") {
//                viewModel.initUserNewInsight()
//            }
            
            WorkoutStreakCardView()
            
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)){
                ForEach(healthManager.hkInsights.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { insight in
                    HKInsightCard(hkInsight: insight.value)
                }
            }
            .padding(.horizontal)
            
            InsightMetricView(viewModel: viewModel)
        }
        .navigationTitle("Insights Page")
        .onAppear {
            healthManager.fetchTodaySteps()
            healthManager.fetchTodayCalories()
            Task {
                try await viewModel.getInsights()
            }
        }
        .onChange(of: showSignInView) { oldValue, newValue in
            Task {
                try await viewModel.refreshInsights()
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var healthManager = HealthManager()
    NavigationStack {
        InsightsView(showSignInView: .constant(false))
            .environmentObject(healthManager)
    }
}

