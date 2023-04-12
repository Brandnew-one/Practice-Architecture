//
//  TodoView.swift
//  TCA-01
//
//  Created by Bran on 2023/04/12.
//

import SwiftUI

import ComposableArchitecture

struct TodoState: Equatable {
  var todos: [Todo] = []
  var isLoading: Bool = false
  var text: String = ""
  @BindingState var textField: String = ""
}

enum TodoAction: Equatable, BindableAction {
  case binding(BindingAction<TodoState>)
  case textFieldChanged(String)
  case fetchList
  case fetchResponse(Result<[Todo], TodoClient.Failure>)
}

struct TodoEnviornment {
  var todoClient: TodoClient
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let todoReducer = AnyReducer<TodoState, TodoAction, TodoEnviornment> { state, action, environment in
  switch action {
  case .binding:
    return .none
  case .textFieldChanged(let text):
    state.text = text
    return .none
  case .fetchList:
    enum FetchList { } // FIXME: -
    state.isLoading = true
    return environment.todoClient
      .fetchTodoList()
      .debounce(
        id: FetchList.self,
        for: 0.1,
        scheduler: environment.mainQueue
      )
      .catchToEffect(TodoAction.fetchResponse)
  case .fetchResponse(.success(let todo)):
    state.isLoading = false
    state.todos = todo
    return .none
  case .fetchResponse(.failure):
    state.isLoading = false
    return .none
  }
}

struct TodoView: View {
  let store: Store<TodoState, TodoAction>

  var body: some View {
    WithViewStore(store) { viewStore in
      ZStack {
        if viewStore.state.isLoading {
          Color.white.opacity(0.3)
            .edgesIgnoringSafeArea(.all)
            .overlay {
              ProgressView().tint(.blue)
            }
        }

        ScrollView(showsIndicators: false) {
          TextField("1", text: viewStore.binding(
            get: \.text,
            send: TodoAction.textFieldChanged
          ))

          TextField("2", text: viewStore.binding(\.$textField))

          Text(viewStore.text)
          Text(viewStore.textField)

          Button(
            action: {
              viewStore.send(.fetchList, animation: .default)
            },
            label: {
              Text("FETCH")
            }
          )

          LazyVStack(spacing: 8) {
            ForEach(viewStore.state.todos) { todo in
              makeTodoRow(todo: todo)
            }
          }
        }
        .clipped()
      }
    }
  }
}

extension TodoView {
  @ViewBuilder
  func makeTodoRow(
    todo: Todo
  ) -> some View {
    HStack(spacing: 20) {
      Text("# \(todo.id)")
        .font(.title)

      Text(todo.title)
        .font(.body)

      Spacer()
    }
    .padding()
    .background(
      todo.completed ? Color.blue : Color.red
    )
  }
}
