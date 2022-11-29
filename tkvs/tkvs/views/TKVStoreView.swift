//
//  ContentView.swift
//  tkvs
//
//  Created by Stephen Parker on 25/11/2022.
//

import SwiftUI

struct TKVStoreView: View {
    
    @StateObject var viewModel: TKVStoreViewModel
    @FocusState private var textFieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            List(viewModel.transactions) { transaction in
                VStack(alignment: .leading) {
                    HStack {
                        Text(">")
                            .foregroundColor(.green)
                        Text("\(transaction.type.rawValue) \(transaction.keyString ?? "") \(transaction.valueString ?? "")")
                            .monospaced()
                            .foregroundColor(.green)
                    }
                    
                    HStack(alignment: .lastTextBaseline) {
                        Text(transaction.transactionResult?.message ?? "")
                            .monospaced()
                    }
                    
                }
                
            }
            .background(.black)
            .scrollContentBackground(.hidden)
            TextField("Enter Command", text: $viewModel.textInput)
                .disableAutocorrection(true)
                .submitLabel(.done)
                .backgroundStyle(.bar)
                .foregroundColor(.white)
                .onSubmit {
                    viewModel.submitSubject.send()
                    textFieldFocused = true
                }
                .focused($textFieldFocused)
        }
        .padding()
        .background(.black)
    }
}

struct TKVStoreView_Previews: PreviewProvider {
    typealias ViewModel = TKVStoreView.TKVStoreViewModel
    private static let previewTKVStoreUseCase = PreviewTKVStoreUseCase()
    @StateObject static var viewModel: ViewModel = .init(tkvStoreUseCase: previewTKVStoreUseCase)

    static var previews: some View {
        TKVStoreView(viewModel: viewModel)
    }
}

extension TKVStoreView_Previews {
    private class PreviewTKVStoreUseCase: TKVStoreUseCaseType {
        var store: [[String : String]] = []
        
        func transact(transaction: Transaction) -> TransactionStatus? {
            return .failed(message: "Test")
        }
    }
}
