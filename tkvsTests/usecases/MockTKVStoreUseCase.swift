//
//  MockTKVStoreUseCase.swift
//  tkvsTests
//
//  Created by Stephen Parker on 29/11/2022.
//

import Foundation
@testable import tkvs


final class MockTKVStoreUseCase: TKVStoreUseCaseType {
    let useCase = TKVStoreUseCase()
    func transact(transaction: Transaction) -> TransactionStatus? {
        return useCase.transact(transaction: transaction)
    }
}
