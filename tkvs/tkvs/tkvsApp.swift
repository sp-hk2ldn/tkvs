//
//  tkvsApp.swift
//  tkvs
//
//  Created by Stephen Parker on 25/11/2022.
//

import SwiftUI

@main
struct tkvsApp: App {
    let tkvStoreUseCase: TKVStoreUseCaseType = TKVStoreUseCase()
    
    var body: some Scene {
        WindowGroup {
            // TODO: - add dependency injection
            TKVStoreView(viewModel: .init(tkvStoreUseCase: tkvStoreUseCase))
        }
    }
}
