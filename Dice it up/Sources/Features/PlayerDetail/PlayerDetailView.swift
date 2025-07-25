//
//  PlayerDetailView.swift
//  Dice it up
//
//  Created by The Real Itto on 23/07/2025.
//

import SwiftUI
import ComposableArchitecture

public struct PlayerDetailView: View {
    let store: StoreOf<PlayerDetail>

    struct Session: Identifiable {
        let id = UUID()
        let date: Date
        let count100s: Int
        let count1s: Int
    }
    
    // Données brutes simulées
    let sessions: [Session] = [
        Session(date: Calendar.current.date(byAdding: .weekOfYear, value: -3, to: Date())!, count100s: 3, count1s: 1),
        Session(date: Calendar.current.date(byAdding: .weekOfYear, value: -2, to: Date())!, count100s: 5, count1s: 0),
        Session(date: Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!, count100s: 2, count1s: 2),
        Session(date: Date(), count100s: 4, count1s: 1)
    ]
    
    public var body: some View {
        List {
            ForEach(sessions.sorted(by: { $0.date > $1.date })) { session in
                VStack(alignment: .leading, spacing: 8) {
                    // Date de session
                    Text(session.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack {
                        // Nombre de 100
                        Label("\(session.count100s) × 100", systemImage: "star.fill")
                            .foregroundColor(.green)
                        Spacer()
                        // Nombre de 1
                        Label("\(session.count1s) × 1", systemImage: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                    }
                    .font(.subheadline)
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("Sessions de \(mockPlayerName)")
        .listStyle(.insetGrouped)
    }
    
    // Juste un nom fictif de joueur
    private let mockPlayerName = "Haoro"
}

#Preview {
    NavigationStack {
        PlayerDetailView(
            store: Store(
                initialState: PlayerDetail.State(
                    player: Player(name: "Haoro",
                                     rolls: [])),
                reducer: {
                    PlayerDetail()
                }
            )
        )
    }

}
