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
    }
    
    enum Action: Equatable {
        
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
            
        }
    }
}
