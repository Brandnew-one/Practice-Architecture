//
//  MovieDetailReducer.swift
//  TCA-MovieSearch
//
//  Created by Bran on 2023/05/04.
//

import Combine
import Foundation

import ComposableArchitecture

// TODO: - Of붙은것과 아닌것의 차이점
struct MovieDetailReducer: ReducerProtocol {
  struct State: Equatable {
    var selectedMovie: Movie
  }

  enum Action: Equatable {
    case saveButtonTapped
    case delButtonTapped
  }

  func reduce(
    into state: inout State,
    action: Action
  ) -> EffectTask<Action> {
    switch action {
    case .saveButtonTapped:
      return .none
    case .delButtonTapped:
      return .none
    }
  }
}
