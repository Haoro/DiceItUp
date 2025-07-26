//
//  PlayerDetail.swift
//  Dice it up
//
//  Created by The Real Itto on 23/07/2025.
//

import Foundation
import ComposableArchitecture

struct PlayerDetail: Reducer {
    
    struct State: Equatable {
        /// Optional state for the player detail page.
        @PresentationState var destination: GroupDetail.State? = nil
        /// The presented Player.
        var player: Player
        /// All the played player's Session.
        var sessions: [Session] = []
    }
    
    enum Action: Equatable {
        /// To load all sessions played by the current Player.
        case loadSessions
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
            
        case .loadSessions:
            let allPlayerSessions = Session.grouped(from: state.player.rolls)
            state.sessions = allPlayerSessions
            return .none
        }
    }
}
