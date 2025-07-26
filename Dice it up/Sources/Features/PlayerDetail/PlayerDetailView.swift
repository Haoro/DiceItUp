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
    
    let sessions: [Session] = [
        Session(date: Date(), rolls: [
            DiceRoll(input: "1d100", result: "1", comment: "Critique absolu!", tags: [], timestamp: Int(Date().addingTimeInterval(-2 * 24 * 3600).timeIntervalSince1970)),  // Critique Ω (1)
            DiceRoll(input: "1d100", result: "7", comment: nil, tags: [], timestamp: Int(Date().addingTimeInterval(-2 * 24 * 3600).timeIntervalSince1970)), // Critique
            DiceRoll(input: "1d100", result: "95", comment: "Oups", tags: [], timestamp: Int(Date().addingTimeInterval(-2 * 24 * 3600).timeIntervalSince1970)), // Fumble
            DiceRoll(input: "1d100", result: "100", comment: "Échec critique Ω", tags: [], timestamp: Int(Date().addingTimeInterval(-2 * 24 * 3600).timeIntervalSince1970)), // Fumble Ω
            
            DiceRoll(input: "1d100", result: "42", comment: nil, tags: [], timestamp: Int(Date().addingTimeInterval(-8 * 24 * 3600).timeIntervalSince1970)), // Normal
            DiceRoll(input: "1d100", result: "5", comment: nil, tags: [], timestamp: Int(Date().addingTimeInterval(-8 * 24 * 3600).timeIntervalSince1970)), // Critique
            DiceRoll(input: "1d100", result: "98", comment: "Catastrophe", tags: [], timestamp: Int(Date().addingTimeInterval(-8 * 24 * 3600).timeIntervalSince1970)), // Fumble
        ]),
        Session(date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
                rolls: [
            DiceRoll(input: "1d100", result: "10", comment: "Critique absolu!", tags: [], timestamp: Int(Date().addingTimeInterval(-2 * 24 * 3600).timeIntervalSince1970)),  // Critique Ω (1)
            DiceRoll(input: "1d100", result: "7", comment: nil, tags: [], timestamp: Int(Date().addingTimeInterval(-2 * 24 * 3600).timeIntervalSince1970)), // Critique
            DiceRoll(input: "1d100", result: "95", comment: "Oups", tags: [], timestamp: Int(Date().addingTimeInterval(-2 * 24 * 3600).timeIntervalSince1970)), // Fumble
            DiceRoll(input: "1d100", result: "34", comment: "Échec critique Ω", tags: [], timestamp: Int(Date().addingTimeInterval(-2 * 24 * 3600).timeIntervalSince1970)), // Fumble Ω
            
            DiceRoll(input: "1d100", result: "42", comment: nil, tags: [], timestamp: Int(Date().addingTimeInterval(-8 * 24 * 3600).timeIntervalSince1970)), // Normal
            DiceRoll(input: "1d100", result: "5", comment: nil, tags: [], timestamp: Int(Date().addingTimeInterval(-8 * 24 * 3600).timeIntervalSince1970)), // Critique
            DiceRoll(input: "1d100", result: "98", comment: "Catastrophe", tags: [], timestamp: Int(Date().addingTimeInterval(-8 * 24 * 3600).timeIntervalSince1970)), // Fumble
        ])
    ]
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                List {
                    ForEach(viewStore.sessions.sorted(by: { $0.date > $1.date })) { session in
                        // Displayed cell for each Session.
                        VStack(alignment: .leading, spacing: 8) {
                            // Date de la session.
                            Text(session.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.system(size: 25,
                                              weight: .bold))
                                .foregroundColor(.primary)
                            VStack {
                                // Critical Succes Row
                                HStack {
                                    Spacer()
                                    // Number of Omega Crit
                                    HStack(spacing: 4) {
                                        Text("⚔")
                                        Text("\(session.nbOfOmegaCritical)")
                                            .monospacedDigit()
                                    }
                                    Spacer()
                                    Spacer()
                                    Spacer()
                                    // Number of Crit
                                    HStack(spacing: 4) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.green)
                                        Text("\(session.nbOfCritical)")
                                    }
                                    Spacer()
                                }
                                .font(.system(size: 30))
                                
                                HStack {
                                    Spacer()
                                    // Number of Omega Crit
                                    HStack(spacing: 4) {
                                        Text("💥")
                                        Text("\(session.nbOfOmegaFumble)")
                                    }
                                        
                                    Spacer()
                                    Spacer()
                                    Spacer()
                                    // Number of Crit
                                    HStack(spacing: 4) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.red)
                                        Text("\(session.nbOfFumble)")
                                    }
                                    Spacer()
                                }
                                .font(.system(size: 30))
                            }
                            
                        }
                        .padding(.vertical, 8)
                    }
                    
                }
                .listStyle(.insetGrouped)
                .onAppear {
                    viewStore.send(.loadSessions)
                }
            }
            .navigationTitle("\(viewStore.player.name)'s Sessions")
        }
    }
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
