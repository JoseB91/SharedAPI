//
//  URLSessionHTTPClient.swift
//  SharedAPI
//
//  Created by José Briones on 20/2/25.
//

import Foundation

public protocol URLSessionProtocol {
    func data(url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
    public func data(url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        try await data(from: url, delegate: delegate)
    }
    
}

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSessionProtocol
    
    public init(session: URLSessionProtocol) {
        self.session = session
    }
            
    public func get(from url: URL) async throws -> (Data, HTTPURLResponse) {
        guard let (data, response) = try? await session.data(url: url, delegate: nil) else {
            throw URLError(.cannotLoadFromNetwork)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        return (data, httpResponse)
    }
}
