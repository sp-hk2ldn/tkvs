//
//  tkvsTests.swift
//  tkvsTests
//
//  Created by Stephen Parker on 25/11/2022.
//

import XCTest
import Combine

@testable import tkvs

@MainActor final class TKVStoreViewModelTests: XCTestCase {
    typealias ViewModel = TKVStoreView.TKVStoreViewModel
    typealias View = TKVStoreView
    
    var viewModel: ViewModel!
    var cancellables: Set<AnyCancellable>!
    
    @MainActor override func setUp() {
        super.setUp()
        cancellables = .init()
        let mockTkvsStoreUseCase = MockTKVStoreUseCase()
        viewModel = .init(tkvStoreUseCase: mockTkvsStoreUseCase)
    }
    
    func testTextInput() {
        var transactions: [Transaction] = []

        let expectation = expectation(description: "transactions")
        
        let expectedTransactions = [
            Transaction(type: .GET, keyString: "this", valueString: nil),
            Transaction(type: .GET, keyString: "this", valueString: "that"),
            Transaction(type: .SET, keyString: "that", valueString: "this")
        ]
        viewModel.transactionSubject
            .compactMap { $0 }
            .sink(receiveValue: {
                print($0)
            })
            .store(in: &cancellables)
        viewModel.textInput = "GET THIS"
        viewModel.textInput = "GET THAT"
        viewModel.textInput = "SET THAT THIS"
        
        
//        XCTAssert(transactions == [.init(type: .SET, keyString: "B", valueString: "A")])
    }
}

