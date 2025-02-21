//
//  MockURLSession.swift
//  SharedAPITests
//
//  Created by José Briones on 20/2/25.
//

import Foundation
@testable import SharedAPI

class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?

    init(mockData: Data? = nil, mockResponse: URLResponse? = nil, mockError: Error? = nil) {
        self.mockData = mockData
        self.mockResponse = mockResponse
        self.mockError = mockError
    }

    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }

        guard let response = mockResponse as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard let data = mockData else {
            throw URLError(.badURL)
        }

        return (data, response)
    }
}
