//
//  InsightMetricView.swift
//  Golympian
//
//  Created by Bernard Scott on 6/27/25.
//

import SwiftUI

struct InsightMetricView: View {
    
    private var currentMonth: String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: now)
    }
    
    @ObservedObject var viewModel: InsightsViewModel
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 1)) {
            HStack {
                Text("\(currentMonth) Workout Summary")
                    .font(.title)
                
                Spacer()
            }
            .padding([.leading])
            
            ScrollView(.horizontal) {
                HStack {
                    Group {
                        WorkoutInsightExerciseActivityCountView(viewModel: viewModel)
                        WorkoutInsightExerciseSetCountView(viewModel: viewModel)
                    }
                    .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                }
                .scrollTargetLayout()
            }
            .contentMargins(16, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            
            HStack {
                Text("\(currentMonth) Exercise Summary")
                    .font(.title)
                
                Spacer()
            }
            .padding([.leading])
            
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
