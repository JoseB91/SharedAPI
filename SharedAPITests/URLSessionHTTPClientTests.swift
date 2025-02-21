//
//  URLSessionHTTPClientTests.swift
//  SharedAPITests
//
//  Created by José Briones on 20/2/25.
//

import XCTest
import SharedAPI

class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromURL_failsWithError_havingError() async throws {
        // Arrange
        let url = anyURL()
        
        //Act
        do {
            _ = try await makeSUT(data: nil, response: nil, error: anyNSError()).get(from: url)
            //Assert
            XCTFail("Expected error, but the call succeeded.")
        } catch {
            //Assert
            XCTAssertNotNil(error)
        }
    }
    
    func test_getFromURL_failsWithBadServerResponse_havingNonHTTPURLResponse() async throws {
        // Arrange
        let url = anyURL()
        
        //Act
        do {
            _ = try await makeSUT(data: anyData(), response: nonHTTPURLResponse(), error: nil).get(from: url)
            //Assert
            XCTFail("Expected error, but the call succeeded.")
        } catch let error as URLError {
            //Assert
            XCTAssertEqual(error.code, .badServerResponse)
        } catch {
            //Assert
            XCTFail("Expected URLError, but received: \(error)")
        }
    }
    
    func test_getFromURL_failsWithError_havingErrorAndNonHTTPURLResponse() async throws {
        // Arrange
        let url = anyURL()
        
        //Act
        do {
            _ = try await makeSUT(data: anyData(), response: nonHTTPURLResponse(), error: anyNSError()).get(from: url)
            //Assert
            XCTFail("Expected error, but the call succeeded.")
        } catch let error as URLError {
            //Assert
            XCTFail("Expected another error, but received: \(error)")
        } catch {
            //Assert
            XCTAssertNotNil(error)
        }
    }
    
    func test_getFromURL_succeedsWithData_havingDataAndAnyHTTPURLResponse() async throws {
        // Arrange
        let url = anyURL()
        let mockedData = anyData()
        let mockedResponse = anyHTTPURLResponse()
        
        // Act
        let (expectedData, expectedResponse) = try await makeSUT(data: mockedData, response: mockedResponse, error: nil).get(from: url)
        
        // Assert
        XCTAssertEqual(expectedData, mockedData)
        XCTAssertEqual(expectedResponse.url, url)
        XCTAssertEqual(expectedResponse.statusCode, mockedResponse.statusCode)
    }
    
    func test_getFromURL_succeedsWithEmptyData_havingEmptyDataAndAnyHTTPURLResponse() async throws {
        // Arrange
        let url = anyURL()
        let emptyData = Data()
        let mockedResponse = anyHTTPURLResponse()
        
        // Act
        let (expectedData, expectedResponse) = try await makeSUT(data: emptyData, response: mockedResponse, error: nil).get(from: url)
        
        // Assert
        XCTAssertEqual(expectedData, emptyData)
        XCTAssertEqual(expectedResponse.url, url)
        XCTAssertEqual(expectedResponse.statusCode, mockedResponse.statusCode)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        
        let mockSession = MockURLSession(mockData: data, mockResponse: response, mockError: error)
        
        let sut = URLSessionHTTPClient(session: mockSession)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
    
    func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    func anyData() -> Data {
        return Data("any data".utf8)
    }
    
    func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    private func nonHTTPURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
}
