//
//  ImageMapper.swift
//  LigasEcAPI
//
//  Created by José Briones on 23/2/25.
//

import Foundation

public final class ImageMapper {
    public enum Error: Swift.Error {
        case invalidData
    }

    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Data {
        guard response.isOK, !data.isEmpty else {
            throw Error.invalidData
        }

        return data
    }
}
