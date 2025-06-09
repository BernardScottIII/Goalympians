//
//  ExerciseFilters.swift
//  Golympian
//
//  Created by Bernard Scott on 6/9/25.
//

import Foundation

enum CategoryOption: String, Codable, CaseIterable {
    case noCategory, abductor, abs, adductors, biceps, calves, cardiovascularSystem, delts, forearms, glutes, hamstrings, lats, levatorScapulae, pectorals, quads, serratusAnterior, spine, traps, triceps, upperBack
    
    var prettyString: String {
        switch self {
        case .noCategory: return "All Muscles"
        case .abductor: return "Abductor"
        case .abs: return "Abdominals/Core"
        case .adductors: return "Adductors"
        case .biceps: return "Biceps"
        case .calves: return "Calves"
        case .cardiovascularSystem: return "Cardio/Heart"
        case .delts: return "Deltoids"
        case .forearms: return "Forearms"
        case .glutes: return "Gluteal Muscles"
        case .hamstrings: return "Hamstrings"
        case .lats: return "Latissimus Dorsi"
        case .levatorScapulae: return "Levator Scapulae (Neck)"
        case .pectorals: return "Pectorals (Chest)"
        case .quads: return "Quadriceps"
        case .serratusAnterior: return "Serratus Anterior"
        case .spine: return "Spine (Lower Back)"
        case .traps: return "Trapezius"
        case .triceps: return "Triceps"
        case .upperBack: return "Upper Back"
        }
    }
}

enum EquipmentOption: String, Codable, CaseIterable {
    case noEquipment, assisted, band, barbell, bodyWeight, bosuBall, cable, dumbbell, ellipticalMachine, ezBarbell, hammer, kettlebell, leverageMachine, medicineBall, olympicBarbell, resistanceBand, roller, rope, skiergMachine, sledMachine, smithMachine, stabilityBall, stationaryBike, stepmillMachine, tire, trapBar, upperBodyErgometer, weighted, wheelRoller, customEquipment
    
    var prettyString: String {
        switch self{
        case .assisted: return "Weight Assisted"
        case .band: return "Band"
        case .barbell: return "Barbell"
        case .bodyWeight: return "Body Weight"
        case .bosuBall: return "Bosu Ball"
        case .cable: return "Cable (Machine)"
        case .dumbbell: return "Dumbbell"
        case .ellipticalMachine: return "Elliptical Machine"
        case .ezBarbell: return "EZ Barbell"
        case .hammer: return "Hammer"
        case .kettlebell: return "Kettlebell"
        case .leverageMachine: return "Leverage Machine"
        case .medicineBall: return "Medicine Ball"
        case .olympicBarbell: return "Olympic Barbell"
        case .resistanceBand: return "Resistance Band"
        case .roller: return "Roller"
        case .rope: return "Rope"
        case .skiergMachine: return "Skierg Machine"
        case .sledMachine: return "Sled Machine"
        case .smithMachine: return "Smith Machine"
        case .stabilityBall: return "Stability Ball"
        case .stationaryBike: return "Stationary Bike"
        case .stepmillMachine: return "Stepmill Machine"
        case .tire: return "Tire"
        case .trapBar: return "Trap Bar"
        case .upperBodyErgometer: return "Upper Body Ergometer"
        case .weighted: return "Weighted"
        case .wheelRoller: return "Wheel Roller"
        case .customEquipment: return "Special/Custom Equipment"
        case .noEquipment: return "No Equipment"
        }
    }
}

enum FilterOption: String, CaseIterable {
    case noFilter
    case nameAscending
    case nameDescending
    
    var nameDescending: Bool? {
        switch self {
        case .noFilter: return nil
        case .nameAscending: return false
        case .nameDescending: return true
        }
    }
    
    var prettyString: String {
        switch self {
        case .noFilter: return "Unsorted"
        case .nameAscending: return "Alphabetical"
        case .nameDescending: return "Reverse Alphabetical"
        }
    }
}
