//
//  RealTimeNumericTextField.swift
//  Goalympians
//
//  Created by Bernard Scott on 4/8/25.
//

import SwiftUI

// Special thanks to Chat-GPT for helping me "override" SwiftUI's TextField
struct RealTimeNumericTextField<Value, Style>: View
where Style: ParseableFormatStyle,
      Style.FormatInput == Value,
      Style.FormatOutput == String {
    
    let titleKey: LocalizedStringKey
    @Binding var value: Value?
    var format: Style
    
    @FocusState private var focused: Bool
    
    var body: some View {
        TextField("", value: $value, format: format)
            .focused($focused)
            .onChange(of: focused) { oldValue, newValue in
                if newValue == false {
                    // do the DB sync
                }
            }
    }
}

#Preview {
    @Previewable @State var value: Double? = nil
    NavigationStack {
        Form {
            RealTimeNumericTextField(titleKey: "", value: $value, format: .number)
        }
    }
}
