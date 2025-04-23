//
//  DBExerciseView.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/22/25.
//

import SwiftUI
import SwiftData

struct DBExerciseView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var exercises: [DevExercise]
    
    var body: some View {
        List {
            ForEach(0..<100, id: \.self) { _ in
                Text("Exercise")
            }
        }
    }
}

#Preview {
    DBExerciseView()
}
