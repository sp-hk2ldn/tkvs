//
//  Transaction.swift
//  tkvs
//
//  Created by Stephen Parker on 28/11/2022.
//

import Foundation

struct Transaction: Identifiable, Equatable {
    let type: TransactionType
    let id = UUID()
    let keyString: String?
    let valueString: String?
    var transactionResult: TransactionStatus?
    
    enum TransactionType: String {
        case SET, GET, DELETE, COUNT, BEGIN, COMMIT, ROLLBACK
    }
}
