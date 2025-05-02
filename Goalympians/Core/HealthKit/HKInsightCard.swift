//
//  HKInsightCard.swift
//  Goalympians
//
//  Created by Bernard Scott on 5/1/25.
//

import SwiftUI

struct HKInsightCard: View {
    @State var hkInsight: HKInsight
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
            VStack {
                HStack(alignment: .top) {
                    VStack {
                        Text(hkInsight.title)
                            .font(.system(size: 16))
                        
                        Text(hkInsight.subtitle)
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                    
                    Image(systemName: hkInsight.image)
                        .foregroundStyle(.green)
                }
                .padding()
                
                Text(hkInsight.amount)
                    .font(.system(size: 24))
            }
            .padding()
            .clipShape(.capsule)
        }
    }
}

#Preview {
    HKInsightCard(hkInsight: HKInsight(id: 1, title: "", subtitle: "", image: "", amount: ""))
}
