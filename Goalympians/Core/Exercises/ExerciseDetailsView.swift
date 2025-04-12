//
//  ExerciseDetailsView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/5/25.
//

import SwiftUI

struct ExerciseDetailsView: View {
    
    let exercise: DBExercise
    
    var body: some View {
        List {
            Text(exercise.name)
            Text(exercise.description)
        }
    }
}

#Preview {
    NavigationStack {
        ExerciseDetailsView(exercise: DBExercise(id: 12309487012, name: "Temporary Exercise", description: "This was created for testing purposes.", userId: "1nqfnN123I1npcY2743hwASDGhfqh"))
    }
}
