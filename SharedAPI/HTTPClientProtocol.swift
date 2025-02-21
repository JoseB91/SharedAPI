//
//  HTTPClientProtocol.swift
//  SharedAPI
//
//  Created by José Briones on 20/2/25.
//

import Foundation

public protocol HTTPClientProtocol {
    func get(from url: URL) async throws -> (Data, HTTPURLResponse)
}
