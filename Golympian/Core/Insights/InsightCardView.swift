//
//  InsightCard.swift
//  Golympian
//
//  Created by Bernard Scott on 6/20/25.
//

import SwiftUI
import Charts

struct InsightCardView: View {
    
    @ObservedObject var viewModel: InsightsViewModel
    
    private var numValidDays: CGFloat {
        var result = 0.0
        for (_, day) in viewModel.userValidDays {
            if day {
                result += 1
            }
        }
        return result
    }
    
    var body: some View {
            
        VStack {
            HStack {
                Text("Workout Streak")
                    .font(.title)
                
                Spacer()
                
                Text("\(viewModel.userCurrentStreak) Weeks")
                    .font(.title)
                    .foregroundStyle(Color(red: 1, green: (124/255), blue: 0))
            }
            .padding()
            
            HStack {
                ZStack {
                    Circle()
                        .stroke(
                            Color(red: 1, green: (174/255), blue: 0, opacity: 0.5),
                            lineWidth: 30
                        )
                    Circle()
                        .trim(
                            from:0,
                            to: (numValidDays/3))
                        .stroke(
                            Color(red: 1, green: (124/255), blue: 0),
                            lineWidth: 30
                        )
                        .rotationEffect(.degrees(-90))
                    
                    if Int(numValidDays) < viewModel.userStreakThreshold {
                        Text("\(Int(numValidDays))/\(viewModel.userStreakThreshold)")
                            .font(.system(size: 32))
                    } else {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 62))
                    }
                }
                .frame(width: 125, height:125)
                .padding([.leading, .trailing])
                
                Spacer()
                
                if Int(numValidDays) < viewModel.userStreakThreshold {
                    Text("Complete \(viewModel.userStreakThreshold) workouts this week to start your streak")
                        .fixedSize(horizontal: false, vertical: true)
                        .scaledToFit()
                } else {
                    Text("Congrats! You're on a streak!")
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .scaledToFit()
            .padding([.leading, .trailing, .bottom])
            
            HStack {
                ForEach(DBUser.StreakValidDayKeys.allCases, id: \.self) { day in
                    VStack {
                        Spacer()
                        if let currentDayStatus = viewModel.userValidDays[day.rawValue] {
                            if currentDayStatus {
                                Image(systemName: "flame.fill")
                                    .frame(width: 10, height: 10)
                            } else {
                                Image(systemName: "minus")
                                    .frame(width: 10, height: 10)
                            }
                        }
                        
                        Text(day.rawValue.prefix(3).localizedCapitalized)
                            .fontWeight(.light)
                    }
                }
            }
            .frame(height: 50)
            .padding([.bottom])
        }
        .background(Color(uiColor: .systemGray6))
        .clipShape(.rect(cornerRadius:15))
        .padding()
        .onAppear {
            Task {
                try await viewModel.getUserStreakData()
            }
        }
    }
}

#Preview {
    InsightCardView(viewModel: InsightsViewModel())
}
