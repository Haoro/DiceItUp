//
//  GroupListReducer.swift
//  Dice it up
//
//  Created by The Real Itto on 16/07/2025.
//

import ComposableArchitecture
import Foundation

/// Décrit l'état de l'écran de sélection de groupe.
struct GroupListState: Equatable {
    var groups: [Group] = []
    var selectedGroupId: UUID?
}

/// Actions disponibles dans l'écran GroupList.
enum GroupListAction: Equatable {
    case loadGroups
    case selectGroup(UUID)
}

/// Dépendances externes de GroupList (simule ici une API).
struct GroupListEnvironment {
    var loadGroups: () -> [Group]
}

/// La logique métier (réduit les actions vers un nouvel état).
struct GroupListReducer: Reducer {
    let environment: GroupListEnvironment

    func reduce(into state: inout GroupListState, action: GroupListAction) -> Effect<GroupListAction> {
        switch action {
        case .loadGroups:
            state.groups = environment.loadGroups()
            return .none

        case let .selectGroup(id):
            state.selectedGroupId = id
            return .none
        }
    }
}
