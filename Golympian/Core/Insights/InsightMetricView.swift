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
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(WorkoutInsight.InsightMetricGrouping.allCases, id: \.self) { grouping in
                        InsightCardView(workoutInsight: viewModel.workoutInsight, insightMetricGrouping: grouping)
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(16, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
        }
    }
}

#Preview {
    @Previewable @StateObject var viewModel = InsightsViewModel()
    ScrollView {
        InsightMetricView(viewModel: viewModel)
    }
}
