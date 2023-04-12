//
//  CounterView.swift
//  TCA-01
//
//  Created by Bran on 2023/04/12.
//

import SwiftUI

import ComposableArchitecture

struct CounterState: Equatable {
  var count = 0
}

enum CounterAction: Equatable {
  case add
  case sub
}

struct CounterEnviornment { }

let counterReducer = AnyReducer<CounterState, CounterAction, CounterEnviornment> { state, action, environment in
  switch action {
  case .add:
    state.count += 1
    return .none
  case .sub:
    state.count -= 1
    return .none
  }
}

struct CounterView: View {
  let store: Store<CounterState, CounterAction>

  var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        Text("Count: \(viewStore.state.count)")
          .font(.title)
          .padding()

        HStack {
          Button(
            action: { viewStore.send(.add) },
            label: {
              Text("ADD")
                .font(.title2)
            }
          )

          Button(
            action: { viewStore.send(.sub) },
            label: {
              Text("SUB")
                .font(.title2)
            }
          )
        }
      }
    }
  }
}

struct CounterView_Previews: PreviewProvider {
  static var previews: some View {
    CounterView(
      store: Store(
        initialState: CounterState(),
        reducer: counterReducer,
        environment: CounterEnviornment()
      )
    )
  }
}
