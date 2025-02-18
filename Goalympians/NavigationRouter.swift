//
//  NavigationRouter.swift
//  Goalympians
//
//  Created by Bernard Scott on 2/17/25.
//

import Foundation
import SwiftUI

final class NavigationRouter: ObservableObject {
    
    @Published var routes = [Route]()
    
    func push(to screen: Route) {
        routes.append(screen)
    }
    
    func reset() {
        routes = []
    }
    
    func pop() {
        routes.removeLast(1)
    }
    
}
