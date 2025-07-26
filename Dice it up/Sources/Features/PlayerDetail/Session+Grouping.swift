//
//  Session+Grouping.swift
//  Dice it up
//
//  Created by The Real Itto on 26/07/2025.
//

import Foundation

extension Session {
    
    /// - Parameter rolls: List of current Player's DiceRolls
    /// - Returns: A list of Sessions of the current Player.
    static func grouped(from rolls: [DiceRoll]) -> [Session] {
        // Calendar needed for the grouped check.
        let calendar = Calendar.current
        
        /// Dictionary of <Date, [DiceRoll]>
        /// Using 'sessionDate' allows past midnight rolls to still be considered the same day.
        let grouped = Dictionary(grouping: rolls) { roll in
            calendar.startOfDay(for: roll.sessionDate)
        }
        
        return grouped
            .sorted { $0.key > $1.key } // Ordered by most recent.
            .map { (date, rolls) in
                Session(date: date, rolls: rolls)
            }
    }
}
