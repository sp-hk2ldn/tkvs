//
//  TKVStoreUseCaseType.swift
//  tkvs
//
//  Created by Stephen Parker on 25/11/2022.
//

import Foundation

protocol TKVStoreUseCaseType {
    func transact(transaction: Transaction) -> TransactionStatus?
}

public enum TransactionStatus: Equatable {
    case written(message: String)
    case retrieved(message: String)
    case deleted(message: String)
    case opened(message: String)
    case committed(message: String)
    case rolledBack(message: String)
    case failed(message: String)
    
    var message: String {
        switch self {
        case .rolledBack(let message):
            return message
        case .failed(let message):
            return message
        case .written(let message):
            return message
        case .retrieved(let message):
            return message
        case .deleted(let message):
            return message
        case .opened(let message):
            return message
        case .committed(let message):
            return message
        }
    }
}

public final class TKVStoreUseCase: TKVStoreUseCaseType {
    private var store: [[String : String]] = [.init()]
    
    func transact(transaction: Transaction) -> TransactionStatus? {
        switch transaction.type {
        case .GET:
            return get(key: transaction.keyString)
        case .SET:
            return set(key: transaction.keyString, value: transaction.valueString)
        case .DELETE:
            return delete(key: transaction.keyString)
        case .BEGIN:
            return begin()
        case .COUNT:
            return count(value: transaction.valueString)
        case .COMMIT:
            return commit()
        case .ROLLBACK:
            return rollback()
        }
    }
    
    private func get(key: String?) -> TransactionStatus {
        guard let key = key else {
            return .failed(message: "GET: No key supplied")
        }
        guard let fetchedValue = store.last?[key] else {
            return .failed(message: "GET: Key not found")
        }
        return .retrieved(message: "GET: \(fetchedValue)")
    }
    
    private func set(key: String?, value: String?) -> TransactionStatus {
        guard let key = key, let value = value else {
            return .failed(message: "SET: Parameter missing")
        }
        var tempStore = store.popLast()
        tempStore?[key] = value
        if let tempStore {
            store.append(tempStore)
            return .written(message: "SET: \(key) as \(value)")
        }
        return .failed(message: "SET \(key) ERROR")
    }
    
    private func delete(key: String?) -> TransactionStatus {
        guard let key = key else { return .failed(message: "DELETE: Parameter missing")}
        var tempStore = store.popLast()
        let removedValue = tempStore?.removeValue(forKey: key)
        if let tempStore {
            store.append(tempStore)
        }
        guard let removedValue = removedValue else { return .failed(message: "DELETE: Key not found") }
        return .deleted(message: "DELETE: \(removedValue) removed for key \(key)")
    }
    
    private func count(value: String?) -> TransactionStatus {
        guard let value = value else { return .failed(message: "COUNT: Parameter missing") }
        return .retrieved(message: "COUNT: \(store.last?.filter { $0.value == value}.count ?? 0)")
    }
    
    private func begin() -> TransactionStatus {
        store.append(store.last ?? [:])
        return .opened(message: "BEGIN:")
    }
    
    private func commit() -> TransactionStatus {
        guard store.count > 1 else { return .failed(message: "COMMIT: No active transaction in progress") }
        let tempStore = store.popLast()
        let indexToReplace = store.count - 1
        guard indexToReplace > -1, let tempStore = tempStore else { return .failed(message: "COMMIT: Unknown Error") }
        store[indexToReplace] = tempStore
        return .committed(message: "COMMIT:")
    }
    
    private func rollback() -> TransactionStatus {
        let transactionInProgress = store.count > 1
        guard transactionInProgress else { return .failed(message: "ROLLBACK: No active transaction in progress")}
        guard store.last != nil else { return .failed(message: "ROLLBACK: Nothing to rollback")  }
        store.removeLast()
        return .rolledBack(message: "ROLLBACK:")
    }
}
