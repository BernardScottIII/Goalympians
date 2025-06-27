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
            ForEach(viewModel.workoutInsight.properties, id: \.key) { property in
                Text("\(property.key): \(property.value)")
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var viewModel = InsightsViewModel()
    InsightMetricView(viewModel: viewModel)
}
