//
//  Player.swift
//  Dice it up
//
//  Created by The Real Itto on 20/07/2025.
//

import Foundation

struct Player: Equatable, Identifiable {
    let id: UUID = UUID()
    let name: String
    var rolls: [DiceRoll]
}

/// Roll à gérer :
/// - 1
/// - 7 (Jackpot)
/// - 8 (Infinite)
/// - 21 (Tarot)
/// - 33 (Expedition)
/// - 42 (Universe Answer)
/// - 50 (Middle man = Buff while talking to random NPCs)
/// - 66 (Devil deal = more weird or dishonest deal proposition)
/// - 69 (Seduction King = Charisma bonus while talking to NPCs.)
/// - 92 (Atlan)
/// - 100
/// - 19/28/37/46/55/64/73/82/91
/// - 11/22/33/44/55/66/77/88/99
///
