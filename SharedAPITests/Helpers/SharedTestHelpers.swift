//
//  SharedTestHelpers.swift
//  SharedAPITests
//
//  Created by José Briones on 23/2/25.
//

import Foundation

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}
