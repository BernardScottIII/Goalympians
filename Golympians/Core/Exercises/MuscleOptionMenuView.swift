//
//  MuscleOptionMenuView.swift
//  Golympians
//
//  Created by Bernard Scott on 7/17/25.
//

import SwiftUI
import FirebaseFirestore

struct MuscleOptionMenuView: View {
    @State private var searchText: String = ""

    @Binding var selection: MuscleOption
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            List {
                ForEach(MuscleOption.allCases.filter{
                    // here's a good place to start for "typing in other names will produce the desired muscle"
                    // i.e: back -> Lats
                    searchText.isEmpty ? true : $0.prettyString.localizedStandardContains(searchText)
                }, id: \.self) { option in
                    Button {
                        selection = option
                        isPresented = false
                    } label: {
                        HStack {
                            if selection == option {
                                Image(systemName: "checkmark")
                            }
                            Text(option.prettyString)
                        }
                    }
                }
            }
            .searchable(text: $searchText)
            .scrollDismissesKeyboard(.immediately)
            .navigationTitle("Primary Muscle")
        }
    }
}

#Preview {
    @Previewable @State var selection: MuscleOption = .allMuscles
    @Previewable @State var showMuscleOptionSheet: Bool = false
    @Previewable @State var targetMuscle: MuscleOption = MuscleOption.allMuscles
    NavigationStack {
        Form {
            Button("Primary Muscle: Developer Preview") {
                showMuscleOptionSheet = true
            }
            .sheet(isPresented: $showMuscleOptionSheet) {
                MuscleOptionMenuView(selection: $targetMuscle, isPresented: .constant(true))
            }
        }
    }
}
