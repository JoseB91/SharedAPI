//
//  URLSessionSpy.swift
//  SharedAPITests
//
//  Created by José Briones on 20/2/25.
//

import Foundation
@testable import SharedAPI

class URLSessionSpy: URLSessionProtocol {
    private(set) var requests = [URLRequest]()

    let result: Result<(Data, URLResponse), Error>

    init(result: Result<(Data, URLResponse), Error>) {
        self.result = result
    }

    func data(url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        self.requests.append(URLRequest(url: url))
        return try result.get()
    }
}
