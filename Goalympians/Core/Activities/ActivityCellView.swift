//
//  ActivityCellView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/7/25.
//

import SwiftUI

struct ActivityCellView: View {
    
    let exercise: DBExercise
    
    var body: some View {
        HStack {
            Text(exercise.name)
            Spacer()
            
        }
    }
}

#Preview {
    ActivityCellView(exercise: DBExercise(id: 0, name: "Sample Exercise", description: "An example exercise for testing purposes.", userId: "SampleUid"))
}
