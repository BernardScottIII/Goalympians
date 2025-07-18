//
//  EquipmentOptionMenuView.swift
//  Golympians
//
//  Created by Bernard Scott on 7/17/25.
//

import SwiftUI
import FirebaseFirestore

struct EquipmentOptionMenuView: View {
    @State private var searchText: String = ""

    @Binding var selection: EquipmentOption
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            List {
                ForEach(EquipmentOption.allCases.filter{
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
            .navigationTitle("Equipment Used")
        }
    }
}

#Preview {
    @Previewable @State var selection: EquipmentOption = .noEquipment
    @Previewable @State var showEquipmentOptionSheet: Bool = false
    @Previewable @State var equipment: EquipmentOption = EquipmentOption.noEquipment
    NavigationStack {
        Form {
            Button("Primary Muscle: Developer Preview") {
                showEquipmentOptionSheet = true
            }
            .sheet(isPresented: $showEquipmentOptionSheet) {
                EquipmentOptionMenuView(selection: $selection, isPresented: .constant(true))
            }
        }
    }
}
