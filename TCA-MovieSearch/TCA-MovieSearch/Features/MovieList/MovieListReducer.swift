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
    var searchResult: [Movie] = []
    var selectMovie: Movie?
    var isNavigation: Bool = false
  }

  enum Action: Equatable {
    case searchTextChanged(String)
    case search
    case selectMovie(Movie)
    case navigation
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
        $0.name.contains(state.searchText)
      }
      return .none
    case .selectMovie(let movie):
      state.selectMovie = movie
      return .run { send in
        await send(.navigation)
      }
    case .navigation:
      state.isNavigation = true
      return .none
    }
  }

  // MARK: - Mock
  private let searchMovies: [Movie] = [
    Movie(
      id: 0,
      name: "웬즈데이",
      originName: "Wednesday",
      posterURL: "https://image.tmdb.org/t/p/original/tNWCukAMubqisamYURvo5jw61As.jpg",
      overview: "똑똑하고 비꼬는 것에 도가 튼 웬즈데이 아담스. 암울함을 풍기는 그녀가 네버모어 아카데미에서 연쇄 살인 사건을 조사하기 시작한다. 새 친구도 사귀고, 앙숙도 만들며",
      rating: 8.762
    ),

    Movie(
      id: 1,
      name: "니가가라하와이",
      originName: "Wednesday",
      posterURL: "https://image.tmdb.org/t/p/original/tNWCukAMubqisamYURvo5jw61As.jpg",
      overview: "똑똑하고 비꼬는 것에 도가 튼 웬즈데이 아담스. 암울함을 풍기는 그녀가 네버모어 아카데미에서 연쇄 살인 사건을 조사하기 시작한다. 새 친구도 사귀고, 앙숙도 만들며",
      rating: 8.762
    )
  ]
}
