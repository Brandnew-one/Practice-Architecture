//
//  TCA_01App.swift
//  TCA-01
//
//  Created by Bran on 2023/04/12.
//

import SwiftUI

import ComposableArchitecture

@main
struct TCA_01App: App {
  let counterStore = Store(
    initialState: CounterState(),
    reducer: counterReducer,
    environment: CounterEnviornment()
  )
  var body: some Scene {
    WindowGroup {
      CounterView(store: counterStore)
    }
  }
}
