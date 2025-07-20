//
//  DiceLogClientTests.swift
//  Dice it up
//
//  Created by Haoro on 20/07/2025.
//

import XCTest

@testable import Dice_it_up

final class DiceLogClientTests: XCTestCase {

    // Test using the testValue that returns static test data
    func testFetchLogsReturnsTestData() async throws {
        let client = DiceLogClient.testValue
        
        let logs = try await client.fetchLogs("any_room")
        
        // We expect the testValue to return an empty array (as defined)
        XCTAssertEqual(logs.count, 0)
    }
    
    // Test decoding a JSON string simulating a Rolz API response
    func testDecodeDiceLogResponse() throws {
        let jsonString = """
        {
            "items": [
                {
                    "type": "dicemsg",
                    "comment": "roll",
                    "input": "d100",
                    "result": "42",
                    "tags": [
                        {"k": "natural 100"}
                    ],
                    "from": "testuser",
                    "time": 1234567890
                }
            ]
        }
        """
        
        let jsonData = Data(jsonString.utf8)
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(DiceLogResponse.self, from: jsonData)
        
        XCTAssertEqual(response.items.count, 1)
        let item = response.items.first!
        XCTAssertEqual(item.type, "dicemsg")
        XCTAssertEqual(item.comment, "roll")
        XCTAssertEqual(item.input, "d100")
        XCTAssertEqual(item.result, "42")
        XCTAssertEqual(item.from, "testuser")
        XCTAssertEqual(item.time, 1234567890)
        XCTAssertEqual(item.tags?.first?.k, "natural 20")
    }
}
