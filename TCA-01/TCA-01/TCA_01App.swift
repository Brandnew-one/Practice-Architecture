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
  
  let todoStore = Store(
    initialState: TodoState(),
    reducer: todoReducer,
    environment: TodoEnviornment(
      todoClient: TodoClient.live,
      mainQueue: .main
    )
  )

  var body: some Scene {
    WindowGroup {
//      CounterView(store: counterStore)
      TodoView(store: todoStore)
    }
  }
}
