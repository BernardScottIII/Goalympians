//
//  WorkoutInsightCardView.swift
//  Golympian
//
//  Created by Bernard Scott on 7/1/25.
//

import SwiftUI
import Charts

struct WorkoutInsightExerciseActivityCountView: View {
    @ObservedObject var viewModel: InsightsViewModel
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 1)) {
            HStack{
                Text("Five Favorite Exercises")
                Spacer()
            }
            .padding()
            
            Chart {
                ForEach(viewModel.exerciseActivityCountsWithNames.prefix(5), id: \.exerciseName) { entry in
                    BarMark(
                        x: .value("Count", entry.count),
                        y: .value("Workout Name", entry.exerciseName)
                    )
                }
            }
            .frame(height: 300)
            .foregroundStyle(Color(red: 1, green: (124/255), blue: 0))
            .chartXAxisLabel("Number of Workouts", alignment: .leading)
            .padding([.leading, .trailing, .bottom])
        }
        .background(Color(uiColor: .systemGray6))
        .clipShape(.rect(cornerRadius:15))
    }
}

#Preview {
    ScrollView {
        WorkoutInsightExerciseActivityCountView(viewModel: InsightsViewModel())
    }
}
