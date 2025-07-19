//
//  GroupListState+Mock.swift
//  Dice it up
//
//  Created by The Real Itto on 18/07/2025.
//

import Foundation
import ComposableArchitecture

extension GroupListState {
    /// État fictif pour les previews et les tests.
    static var mock: GroupListState {
        GroupListState(
            groups: [
                Group(id: UUID(), name: "Mock Group 1"),
                Group(id: UUID(), name: "Mock Group 2"),
                Group(id: UUID(), name: "Mock Group 3")
            ],
            selectedGroupId: nil
        )
    }
}
