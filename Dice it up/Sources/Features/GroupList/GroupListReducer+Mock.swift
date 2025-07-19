//
//  GroupListReducer+Mock.swift
//  Dice it up
//
//  Created by The Real Itto on 18/07/2025.
//

import ComposableArchitecture

extension GroupListReducer {
    /// Reducer fictif avec un environnement simplifié, pour les previews/tests.
    static var mock: GroupListReducer {
        GroupListReducer(
            environment: GroupListEnvironment(
                loadGroups: { [] } // Aucun effet réel dans la preview
            )
        )
    }
}
