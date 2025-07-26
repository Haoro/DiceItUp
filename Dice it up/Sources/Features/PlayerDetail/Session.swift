//
//  Session.swift
//  Dice it up
//
//  Created by The Real Itto on 26/07/2025.
//

import Foundation

/// Played by a group of players at a given date.
struct Session: Equatable, Identifiable {
    /// Session unique id.
    let id: UUID = UUID()
    /// When was the session played.
    let date: Date
    /// All the rolls played by a given player in the session.
    let rolls: [DiceRoll]
    /// Number of 1 rolled in the session.
    var nbOfOmegaCritical: Int {
        rolls.filter { $0.result == "1" }.count
    }
    /// Number of 1-10 rolled in the session.
    var nbOfCritical: Int {
        rolls.compactMap { Int($0.result) }
            .filter { (2...10).contains($0) }
            .count
    }
    /// Number of 100 rolled in the session.
    var nbOfOmegaFumble: Int {
        rolls.filter { $0.result == "100" }.count
    }
    /// Number of 91-100 rolled in the session.
    var nbOfFumble: Int {
        rolls.compactMap { Int($0.result) }
            .filter { (91...99).contains($0) }
            .count
    }
    
    
}
