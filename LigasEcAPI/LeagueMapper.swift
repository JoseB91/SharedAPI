//
//  LeagueMapper.swift
//  LigasEcAPI
//
//  Created by José Briones on 23/2/25.
//

import Foundation

//GET : https://v3.football.api-sports.io/leagues?country=Ecuador&season=2023

public final class LeagueMapper {
    
    private struct Root: Decodable {
        let errors: [String]
        let response: [Response]
                
        var leagues: [League] {
            response.compactMap { League(id: $0.league.id,
                                         name: $0.league.name,
                                         logoURL: $0.league.logo)
            }
        }
                            
        struct Response: Codable {
            let league: League
            let country: Country
           
            struct Country: Codable {
                let name, code: String
                let flag: String
            }
            
            struct League: Codable {
                let id: Int
                let name, type: String
                let logo: URL
            }
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
        case unsuccessfullyResponse
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [League] {
        guard response.isOK else {
            throw Error.unsuccessfullyResponse
        }
        
        do {
            let root = try JSONDecoder().decode(Root.self, from: data)
            return root.leagues
        } catch {
            throw Error.invalidData
        }
    }
}

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}

public struct League: Hashable {
    public let id: Int
    public let name: String
    public let logoURL: URL
    
    public init(id: Int, name: String, logoURL: URL) {
        self.id = id
        self.name = name
        self.logoURL = logoURL
    }
}

//{
//    "get": "leagues",
//    "parameters": {
//        "country": "Ecuador",
//        "season": "2023"
//    },
//    "errors": [],
//    "results": 3,
//    "paging": {
//        "current": 1,
//        "total": 1
//    },
//    "response": [{
//        "league": {
//            "id": 242,
//            "name": "Liga Pro",
//            "type": "League",
//            "logo": "https://media.api-sports.io/football/leagues/242.png"
//        },
//        "country": {
//            "name": "Ecuador",
//            "code": "EC",
//            "flag": "https://media.api-sports.io/flags/ec.svg"
//        },
//        "seasons": [{
//            "year": 2023,
//            "start": "2023-02-25",
//            "end": "2023-12-17"}]
//    }]
//}
