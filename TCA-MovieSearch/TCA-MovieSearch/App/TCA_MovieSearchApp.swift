//
//  TCA_MovieSearchApp.swift
//  TCA-MovieSearch
//
//  Created by Bran on 2023/05/04.
//

import SwiftUI

import ComposableArchitecture

@main
struct TCA_MovieSearchApp: App {
  let movieListStore = Store(
    initialState: MovieListReducer.State(),
    reducer: MovieListReducer()
  )
  
  var body: some Scene {
    WindowGroup {
      MovieListView(store: movieListStore)
    }
  }
}
