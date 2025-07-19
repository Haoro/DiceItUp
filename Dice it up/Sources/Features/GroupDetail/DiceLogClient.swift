//
//  DiceLogClient.swift
//  Dice it up
//
//  Created by Haoro on 19/07/2025.
//

import Foundation
import ComposableArchitecture

/// Represents a single dice log item from the API.
struct DiceLogItem: Decodable, Equatable {
    let type: String            // Type of message (e.g. "dicemsg").
    let comment: String?        // Optional comment attached to the roll.
    let input: String?          // The dice input string (e.g. "d100 #roulade").
    let result: String?         // Result of the dice roll as a string.
    let tags: [Tag]?            // Optional array of tags for special roll properties.
    let from: String?           // Player or user who rolled the dice.
    let time: Int?              // Unix timestamp (seconds since 1970).
    
    /// Represents key-value tags in a dice roll, e.g. "natural 100".
    struct Tag: Decodable, Equatable {
        let k: String
    }
}

/// Root response for dice logs from the API.
struct DiceLogResponse: Decodable {
    let items: [DiceLogItem]
}

/// Client responsible for fetching dice logs from the Rolz API.
struct DiceLogClient {
    /// Async function to fetch dice logs for a given room name.
    /// - Parameter room: The room name (part of URL).
    /// - Returns: An array of `DiceLogItem` filtered for type "dicemsg".
    var fetchLogs: @Sendable (_ room: String) async throws -> [DiceLogItem]
}

extension DiceLogClient: DependencyKey {
    static let liveValue = DiceLogClient { room in
        // Construct the API URL.
        let url = URL(string: "https://rolz.org/api/roomlog?room=\(room)")!
        
        // Perform network request asynchronously.
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Decode the JSON response into model objects.
        let decoder = JSONDecoder()
        let response = try decoder.decode(DiceLogResponse.self, from: data)
        
        // Filter only items where :
        //   - type is "dicemsg".
        //   - input starts with d100 (to not count any results that may be from other dice).
        let diceMessages = response.items.filter { item in
            item.type == "dicemsg" && (item.input?.hasPrefix("d100") ?? false)
        }
        return diceMessages
    }
    
    // Test implementation returning an empty list.
    static let testEmptyValue = DiceLogClient { _ in
        return []
    }
    
    // Test value with example dice log items.
        static let testValue = DiceLogClient { _ in
            return [
                DiceLogItem(
                    type: "dicemsg",
                    comment: "critical hit",
                    input: "d20 + 5",
                    result: "25",
                    tags: [DiceLogItem.Tag(k: "natural 20")],
                    from: "PlayerOne",
                    time: 1752964018
                ),
                DiceLogItem(
                    type: "dicemsg",
                    comment: "stealth check",
                    input: "d20",
                    result: "17",
                    tags: nil,
                    from: "PlayerTwo",
                    time: 1752964025
                ),
                DiceLogItem(
                    type: "dicemsg",
                    comment: nil,
                    input: "d6",
                    result: "4",
                    tags: nil,
                    from: "PlayerThree",
                    time: 1752964030
                )
            ]
        }
}

// Extension to make DiceLogClient accessible in the Swift Composable Architecture's dependency system.
extension DependencyValues {
    var diceLogClient: DiceLogClient {
        get { self[DiceLogClient.self] }
        set { self[DiceLogClient.self] = newValue }
    }
}
