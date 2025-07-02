//
//  InsightMetricView.swift
//  Golympian
//
//  Created by Bernard Scott on 6/27/25.
//

import SwiftUI

struct InsightMetricView: View {
    
    @ObservedObject var viewModel: InsightsViewModel
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 1)) {
            WorkoutInsightCardView(viewModel: viewModel)
            
            ForEach(WorkoutInsight.InsightMetricGrouping.allCases, id: \.self) { grouping in
                InsightCardView(workoutInsight: viewModel.workoutInsight, insightMetricGrouping: grouping)
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var viewModel = InsightsViewModel()
    ScrollView {
        InsightMetricView(viewModel: viewModel)
    }
}
