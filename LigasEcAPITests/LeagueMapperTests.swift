//
//  LeagueMapperTests.swift
//  LigasEcAPITests
//
//  Created by José Briones on 23/2/25.
//

import XCTest
import LigasEcAPI

final class LeagueMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        // Arrange
        let json = makeJSON("")
        let samples = [199, 201, 300, 400, 500]

        try samples.forEach { code in
            // Assert
            XCTAssertThrowsError(
                // Act
                try LeagueMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }

    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        // Arrange
        let invalidJSON = Data("invalid json".utf8)

        // Assert
        XCTAssertThrowsError(
            // Act
            try LeagueMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }

    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        // Arrange
        let item = makeLeagueItem()
        let jsonString = """
{\"get\": \"leagues\",\"parameters\": {\"country\": \"Ecuador\"},
        \"errors\": [],
        \"results\": 1,
        \"paging\": {
          \"current\": 1,
          \"total\": 1
        },
        \"response\": [
          {
            \"league\": { \"id\": 242,
            \"name\": \"Liga Pro\",
            \"type\": \"League\",
            \"logo\": \"https://media.api-sports.io/football/leagues/242.png\"
              },
            \"country\": { \"name\": \"Ecuador\",
            \"code\": \"EC\",
            \"flag\": \"https://media.api-sports.io/flags/ec.svg\"
              },
            \"seasons\": [{ \"year\": 2023,
            \"start\": \"2023-02-25\",
            \"end\": \"2023-12-17\"
              },
            ]
          }
        ]
      }
"""
        let json = makeJSON(jsonString)

        // Act
        let result = try LeagueMapper.map(json,
                                          from: HTTPURLResponse(statusCode: 200))

        // Assert
        XCTAssertEqual(result, [item])
    }

    // MARK: - Helpers

    func makeLeagueItem() -> League {
        League(id: 242,
            name: "Liga Pro",
            logoURL: URL(string: "https://media.api-sports.io/football/leagues/242.png")!)
        
    }
    
    func makeJSON(_ jsonString: String) -> Data {
        return jsonString.data(using: .utf8)!
    }
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
