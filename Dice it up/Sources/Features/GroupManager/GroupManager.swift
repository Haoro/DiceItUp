//
//  GroupManager.swift
//  Dice it up
//
//  Created by Haoro on 19/07/2025.
//

import Foundation
import ComposableArchitecture

/// Groups manager for main screen.
struct GroupManager: Reducer {
    
    // State
    struct State: Equatable {
        var groupName: String = ""
        var urlPart: String = ""
    }

    // Action
    enum Action: Equatable {
        case groupNameChanged(String)
        case urlPartChanged(String)
        case confirmTapped
        case cancelTapped
        case presented(PresentationAction<Self>)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .groupNameChanged(name):
            state.groupName = name
            return .none
        case let .urlPartChanged(code):
            state.urlPart = code
            return .none
        case .confirmTapped, .cancelTapped:
            return .none
        case .presented(_):
            return .none
        }
    }
}
