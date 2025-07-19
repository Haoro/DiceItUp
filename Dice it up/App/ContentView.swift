//
//  ContentView.swift
//  Dice it up
//
//  Created by The Real Itto on 17/07/2025.
//

import SwiftUI
import ComposableArchitecture

/// La vue racine de ton application.
/// Elle affiche la liste des groupes via le store de GroupListReducer.
struct ContentView: View {
    var body: some View {
        GroupListView(
            store: Store(
                initialState: GroupListState(),
                reducer: {
                    GroupListReducer(
                        environment: GroupListEnvironment(
                            loadGroups: {
                                // Simule une liste de groupes, à remplacer plus tard par une API réseau.
                                [
                                    Group(id: UUID(), name: "Groupe Alpha"),
                                    Group(id: UUID(), name: "Les Lancers Fous"),
                                    Group(id: UUID(), name: "Ordre de la Table Carrée")
                                ]
                            }
                        )
                    )
                }
            )
        )
    }
}
