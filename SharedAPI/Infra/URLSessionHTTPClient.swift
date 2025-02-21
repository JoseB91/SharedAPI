//
//  URLSessionHTTPClient.swift
//  SharedAPI
//
//  Created by José Briones on 20/2/25.
//

import Foundation

public protocol URLSessionProtocol {
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSessionProtocol
    
    public init(session: URLSessionProtocol) {
        self.session = session
    }
            
    public func get(from url: URL) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await session.data(from: url, delegate: nil)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        return (data, httpResponse)
    }
}

