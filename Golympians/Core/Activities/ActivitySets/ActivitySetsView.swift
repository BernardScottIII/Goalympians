//
//  ActivitySetView.swift
//  Golympian
//
//  Created by Bernard Scott on 6/11/25.
//

import SwiftUI
import FirebaseFirestore

struct ActivitySetsView: View {
    
    @State private var setValues: [[String:String]] = []
    
    @ObservedObject var viewModel: ActivityViewModel
    let workoutId: String
    @Binding var activity: DBActivity
    
    init(
        viewModel: ActivityViewModel,
        workoutId: String,
        activity: Binding<DBActivity>
    ) {
        self.viewModel = viewModel
        self.workoutId = workoutId
        self._activity = activity
        
        if !activity.wrappedValue.activitySets.isEmpty {
            self._setValues = State(initialValue: mapSetValues())
        }
    }
    
    var body: some View {
        // This code sucks.
        ForEach($activity.activitySets.indices, id: \.self) { index in
            HStack {
                switch activity.setType {
                case .resistanceSet:
                    ResistanceSetView(
                        weight: Binding(
                            get: {
                                setValues[index]["weight"] ?? "0"
                            },
                            set: { newValue in
                                setValues[index]["weight"] = newValue
                            }
                        ),
                        repetitions: Binding(
                            get: {
                                setValues[index]["repetitions"] ?? "0"
                            },
                            set: { newValue in
                                setValues[index]["repetitions"] = newValue
                            }
                        ))
                case .runSet:
                    RunSetView(
                        distance: Binding(
                            get: {
                                setValues[index]["distance"] ?? "0"
                            },
                            set: { newValue in
                                setValues[index]["distance"] = newValue
                            }
                        ),
                        duration: Binding(
                            get: {
                                setValues[index]["duration"] ?? "0"
                            },
                            set: { newValue in
                                setValues[index]["duration"] = newValue
                            }
                        ),
                        elevation: Binding(
                            get: {
                                setValues[index]["elevation"] ?? "0"
                            },
                            set: { newValue in
                                setValues[index]["elevation"] = newValue
                            }
                        )
                    )
                case .swimSet:
                    SwimSetView(
                        distance: Binding(
                            get: {
                                setValues[index]["distance"] ?? "0"
                            },
                            set: { newValue in
                                setValues[index]["distance"] = newValue
                            }
                        ),
                        duration: Binding(
                            get: {
                                setValues[index]["duration"] ?? "0"
                            },
                            set: { newValue in
                                setValues[index]["duration"] = newValue
                            }
                        ),
                        laps: Binding(
                            get: {
                                setValues[index]["laps"] ?? "0"
                            },
                            set: { newValue in
                                setValues[index]["laps"] = newValue
                            }
                        )
                    )
                }
                
                Button("", systemImage: "trash") {
                    removeActivitySet(at: index)
                }
            }
            .buttonStyle(.plain)
        }
        // It is so bad on so many levels (at least two here).
        .onChange(of: setValues) { oldValue, newValue in
            viewModel.updateActivity(
                workoutId: workoutId,
                activity: DBActivity(
                    id: activity.id,
                    exerciseId: activity.exerciseId,
                    setType: activity.setType,
                    workoutIndex: activity.workoutIndex,
                    activitySets: mapActivitySetValues()
                )
            )
        }
        .onChange(of: activity.activitySetsHash) { oldValue, newValue in
            setValues = mapSetValues()
        }
    }
    
    private func removeActivitySet(at index: Int) {
        viewModel.removeActivitySet(workoutId: workoutId, activityId: activity.id, set: activity.activitySets[index])
        var reorderedSets = activity.activitySets
        reorderedSets.remove(at: index)
        // There's certainly a better way to write this loop
        for (idx, _) in reorderedSets.enumerated() {
            print(reorderedSets[idx])
            reorderedSets[idx]["set_index"] = idx
        }
        viewModel.updateActivity(
            workoutId: workoutId,
            activity: DBActivity(
                id: activity.id,
                exerciseId: activity.exerciseId,
                setType: activity.setType,
                workoutIndex: activity.workoutIndex,
                activitySets: reorderedSets
            )
        )
        viewModel.getAllActivities(workoutId: workoutId)
    }
    
    private func mapSetValues() -> [[String:String]] {
        return activity.activitySets.map { dict in
            var stringDict: [String:String] = [:]
            for (key, value) in dict {
                stringDict[key] = "\(value)"
            }
            return stringDict
        }
    }
    
    private func mapActivitySetValues() -> [[String:Any]] {
        var result: [[String:Any]] = []
        for set in setValues {
            var tempDict: [String:Any] = [:]
            for key in set.keys {
                if let doubleValue = Double(set[key]!) {
                    tempDict[key] = doubleValue
                } else if let intValue = Int(set[key]!) {
                    tempDict[key] = intValue
                } else {
                    tempDict[key] = 0
                }
            }
            result.append(tempDict)
        }
        return result
    }
}

#Preview {
    @Previewable let dataService = ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts"))
    @Previewable @State var activity = DBActivity(
        id: "VZQJzIRor2Lpm3jd8xbL",
        exerciseId: "0FE5722A-7D35-4307-9B37-D85B7CEB29D9",
        setType: .resistanceSet,
        workoutIndex: 1,
        activitySets: [
            ["weight": 1.5, "set_index": 0, "repetitions": 10],
            ["weight": 2.5, "set_index": 1, "repetitions": 8],
            ["weight": 3.5, "set_index": 2, "repetitions": 6],
        ]
    )
    List {
        ActivitySetsView(
            viewModel: ActivityViewModel(dataService: dataService),
            workoutId: "04B1B625-2862-4D97-A071-C80AB24CC16C",
            activity: $activity
        )
    }
}
