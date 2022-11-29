//
//  TestData.swift
//  tkvsTests
//
//  Created by Stephen Parker on 29/11/2022.
//

import Foundation
@testable import tkvs

struct TestData {}

extension TestData {
    static let getTransactionsTestCaseData: [Transaction] = [
        .init(type: .SET, keyString: "foo", valueString: "123"),
        .init(type: .GET, keyString: "foo", valueString: nil)
    ]
    
    static let deleteTransactionsTestCaseData: [Transaction] = [
        .init(type: .SET, keyString: "foo", valueString: "123"),
        .init(type: .DELETE, keyString: "foo", valueString: nil),
        .init(type: .GET, keyString: "foo", valueString: nil)
    ]
    
    static let countTransactionsTestCaseData: [Transaction] = [
        .init(type: .SET, keyString: "foo", valueString: "123"),
        .init(type: .SET, keyString: "bar", valueString: "456"),
        .init(type: .SET, keyString: "baz", valueString: "123"),
        .init(type: .COUNT, keyString: nil, valueString: "123"),
        .init(type: .COUNT, keyString: nil, valueString: "456")
    ]
    
    static let commitTransactionsTestCaseData: [Transaction] = [
        .init(type: .SET, keyString: "bar", valueString: "123"),
        .init(type: .GET, keyString: "bar", valueString: nil),
        .init(type: .BEGIN, keyString: nil, valueString: nil),
        .init(type: .SET, keyString: "foo", valueString: "457"),
        .init(type: .GET, keyString: "bar", valueString: nil),
        .init(type: .DELETE, keyString: "bar", valueString: nil),
        .init(type: .COMMIT, keyString: nil, valueString: nil),
        .init(type: .GET, keyString: "bar", valueString: nil),
        .init(type: .ROLLBACK, keyString: nil, valueString: nil),
        .init(type: .GET, keyString: "foo", valueString: nil)
    ]
}
