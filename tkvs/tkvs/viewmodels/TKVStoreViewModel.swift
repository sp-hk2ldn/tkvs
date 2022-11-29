//
//  TKVStoreViewModel.swift
//  tkvs
//
//  Created by Stephen Parker on 25/11/2022.
//

import Foundation
import SwiftUI
import Combine

extension TKVStoreView {
    @MainActor final class TKVStoreViewModel: ObservableObject {
        @Published var textInput: String = ""
        let submitSubject: PassthroughSubject<Void, Never> = .init()
        @Published var transactions: [Transaction] = []
        let transactionSubject: CurrentValueSubject<Transaction?, Never> = .init(nil)
        
        private var commandTypePublisher: AnyPublisher<Transaction.TransactionType?, Never> {
            $textInput
                .filter { !$0.isEmpty }
                .map { input in
                    input.split(separator: " ")[0].uppercased()
                }
                .map { String($0) }
                .map {
                    Transaction.TransactionType(rawValue: $0) ?? nil
                }
                .eraseToAnyPublisher()
        }
        
        private var parametersPublisher: AnyPublisher<[String], Never> {
            $textInput
                .filter { !$0.isEmpty }
                .map { input in
                    input.split(separator: " ").map { String($0) }
                }
                .eraseToAnyPublisher()
        }
        
        private var commandPublisher: AnyPublisher<Transaction?, Never> {
            commandTypePublisher.combineLatest(parametersPublisher)
                .map { transactionType, params in
                    guard let transactionType = transactionType else { return nil }
                    if transactionType == .BEGIN || transactionType == .COMMIT || transactionType == .ROLLBACK {
                        return .init(type: transactionType, keyString: nil, valueString: nil)
                    }
                    var valueString: String?
                    var keyString: String?
                    if params.indices.contains(1) {
                        if transactionType == .COUNT {
                            valueString = params[1]
                        } else {
                            keyString = params[1]
                        }
                    }
                    if params.indices.contains(2) {
                        valueString = params[2]
                    }
                    return .init(type: transactionType, keyString: keyString, valueString: valueString, transactionResult: nil)
                }
                .eraseToAnyPublisher()
        }
        
        let tkvStoreUseCase: TKVStoreUseCaseType
        
        init(tkvStoreUseCase: TKVStoreUseCaseType) {
            self.tkvStoreUseCase = tkvStoreUseCase
            commandPublisher
                .sink(receiveValue: { [weak self] transaction in
                    self?.transactionSubject.send(transaction)
                })
                .store(in: &cancellables)
            
            submitSubject
                .throttle(for: .milliseconds(400), scheduler: RunLoop.main, latest: false)
                .sink(receiveValue: { [weak self] _ in
                    guard var transaction = self?.transactionSubject.value else { return }
                    transaction.transactionResult = tkvStoreUseCase.transact(transaction: transaction)
                    self?.transactions.append(transaction)
                })
                .store(in: &cancellables)
        }
        
        private var cancellables: Set<AnyCancellable> = []
    }
}
