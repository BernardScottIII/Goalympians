//
//  WorkoutFilters.swift
//  Golympians
//
//  Created by Bernard Scott on 7/16/25.
//

import Foundation

enum DateOption: String, CaseIterable {
    case noFilter
    case dateAscending
    case dateDescending
    
    var dateDescending: Bool? {
        switch self {
        case .noFilter: return nil
        case .dateAscending: return false
        case .dateDescending: return true
        }
    }
    
    var prettyString: String {
        switch self {
        case .noFilter: return "Unsorted"
        case .dateAscending: return "Oldest"
        case .dateDescending: return "Newest"
        }
    }
}
