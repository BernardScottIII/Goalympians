//
//  WorkoutInsightCardView.swift
//  Golympian
//
//  Created by Bernard Scott on 7/1/25.
//

import SwiftUI
import Charts

struct WorkoutInsightCardView: View {
    @ObservedObject var viewModel: InsightsViewModel
    
    private var currentMonth: String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: now)
    }
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 1)) {
            HStack {
                Text("\(currentMonth) Workout Summary")
                    .font(.title)
            }
            .padding()
            
            HStack{
                Text("Five Favorite Exercises")
                Spacer()
            }
            .padding([.leading, .trailing])
            
            Chart {
                ForEach(viewModel.exerciseCountsWithName.prefix(5), id: \.exerciseName) { entry in
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
        .padding()
    }
}

#Preview {
    ScrollView {
        WorkoutInsightCardView(viewModel: InsightsViewModel())
    }
}
