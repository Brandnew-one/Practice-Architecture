//
//  MovieListReducer.swift
//  TCA-MovieSearch
//
//  Created by Bran on 2023/05/04.
//

import Combine
import Foundation

import ComposableArchitecture

// TODO: - Equatable 채택 이유 확인해보기
struct MovieListReducer: ReducerProtocol {
  struct State: Equatable {
    var searchText: String = ""
    var searchResult: [String] = []
  }

  enum Action: Equatable {
    case searchTextChanged(String)
    case search
  }

  func reduce(
    into state: inout State,
    action: Action
  ) -> EffectTask<Action> {
    switch action {
    case .searchTextChanged(let search):
      state.searchText = search
      return .none
    case .search:
      state.searchResult = searchMovies.filter {
        $0.contains(state.searchText)
      }
      return .none
    }
  }

  private let searchMovies: [String] = [
    "도망쳐",
    "Run",
    "돔황챠",
    "고민고민하지마"
  ]
}
