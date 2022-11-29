//
//  TKVStoreUseCaseTests.swift
//  tkvsTests
//
//  Created by Stephen Parker on 29/11/2022.
//

import Foundation
import XCTest
@testable import tkvs

final class TKVStoreUseCaseTests: XCTestCase {
    private var store: [[String: String]]!
    private var useCase: TKVStoreUseCaseType!
    
    override func setUp() {
        super.setUp()
        useCase = MockTKVStoreUseCase()
    }
    
    func testGet() {
        let results = TestData.getTransactionsTestCaseData.compactMap { useCase.transact(transaction: $0) }
        XCTAssert(
            results == [
                .written(message: "SET: foo as 123"),
                .retrieved(message: "GET: 123")
            ]
        )
    }
    
    func testDelete() {
        let results = TestData.deleteTransactionsTestCaseData.compactMap { useCase.transact(transaction: $0) }
        XCTAssert(
            results == [
                .written(message: "SET: foo as 123"),
                .deleted(message: "DELETE: 123 removed for key foo"),
                .failed(message: "GET: Key not found")
            ]
        )
    }
    
    func testCount() {
        let results = TestData.countTransactionsTestCaseData.compactMap { useCase.transact(transaction:$0) }
        XCTAssert(
            results == [
                .written(message: "SET: foo as 123"),
                .written(message: "SET: bar as 456"),
                .written(message: "SET: baz as 123"),
                .retrieved(message: "COUNT: 2"),
                .retrieved(message: "COUNT: 1")
            ]
        )
    }
    
    func testCommit() {
        let results = TestData.commitTransactionsTestCaseData.compactMap { useCase.transact(transaction:$0) }
        XCTAssert(
            results == [
                .written(message: "SET: bar as 123"),
                .retrieved(message: "GET: 123"),
                .opened(message: "BEGIN:"),
                .written(message: "SET: foo as 457"),
                .retrieved(message: "GET: 123"),
                .deleted(message: "DELETE: 123 removed for key bar"),
                .committed(message: "COMMIT:"),
                .failed(message: "GET: Key not found"),
                .failed(message: "ROLLBACK: No active transaction in progress"),
                .retrieved(message: "GET: 457")
            ]
        )
    }
}
