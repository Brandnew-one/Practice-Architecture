//
//  MemoClient.swift
//  TCA-01
//
//  Created by Bran on 2023/04/12.
//

import Foundation

import ComposableArchitecture

struct TodoClient {
  var fetchTodoList: () -> Effect<[Todo], Failure>
  struct Failure: Error, Equatable { }
}

extension TodoClient {
  static let live = Self(
    fetchTodoList: {
      Effect.task {
        let (data, _) = try await URLSession.shared.data(
          from: URL(string: "https://jsonplaceholder.typicode.com/users/1/todos")!
        )
        return try JSONDecoder().decode([Todo].self, from: data)
      }
      .mapError { _ in Failure() }
      .eraseToEffect()
    }
  )
}
