//
//  InsightCardView.swift
//  Golympian
//
//  Created by Bernard Scott on 7/1/25.
//

import SwiftUI

struct InsightCardView: View {
    
    private let insightMetricGroup: [Any]
    private let insightMetricSymbol: String
    
    let insightMetricGrouping: WorkoutInsight.InsightMetricGrouping
    
    init(
        workoutInsight: WorkoutInsight,
        insightMetricGrouping: WorkoutInsight.InsightMetricGrouping
    ) {
        self.insightMetricGrouping = insightMetricGrouping
        self.insightMetricGroup = workoutInsight.getMetricGrouping(insightMetricGrouping)
        self.insightMetricSymbol = workoutInsight.getMetricSymbol(insightMetricGrouping)
    }
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 1)) {
            HStack {
                Text("\(insightMetricGrouping.rawValue)")
                    .font(.title)
                
                Spacer()
                
                Image(insightMetricSymbol)
                    .foregroundStyle(Color(red: 1, green: (124/255), blue: 0))
                    .font(.system(size: 48))
            }
            .padding()
            
            HStack{
                VStack(alignment: .leading) {
                    Text("Total \(insightMetricGrouping.rawValue) this month: \(insightMetricGroup[0])")
                    Text("Highest \(insightMetricGrouping.rawValue) recorded this month: \(insightMetricGroup[2])")
                }
                
                Spacer()
            }
            .padding()
        }
        .background(Color(uiColor: .systemGray6))
        .clipShape(.rect(cornerRadius:15))
        .padding()
    }
}

#Preview {
    InsightCardView(workoutInsight: .init(id: UUID().uuidString, date: Date.now), insightMetricGrouping: .elevation)
}
