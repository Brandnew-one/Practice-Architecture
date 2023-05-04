//
//  MovieListView.swift
//  TCA-MovieSearch
//
//  Created by Bran on 2023/05/04.
//

import SwiftUI

import ComposableArchitecture

struct MovieListView: View {
  let store: StoreOf<MovieListReducer>

  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        VStack {
          HStack {
            TextField(
              "Search Field",
              text: Binding(
                get: { viewStore.searchText },
                set: { viewStore.send(.searchTextChanged($0)) }
              )
            )

            Button(
              action: { viewStore.send(.search) },
              label: { Text("Search") }
            )
          }
          .padding()

          ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 10) {
              NavigationLink(
                isActive: Binding(
                  get: { viewStore.isNavigation },
                  set: { _, _ in  }
                ),
                destination: {
                  if let selectedMovie = viewStore.selectMovie {
                    let store = Store(
                      initialState: MovieDetailReducer.State(selectedMovie: selectedMovie),
                      reducer: MovieDetailReducer()
                    )
                    MovieDetailView(store: store)
                  }
                },
                label: { EmptyView() }
              )

              ForEach(viewStore.searchResult) { result in
                Button(
                  action: { viewStore.send(.selectMovie(result)) },
                  label: { MovieListRow(movie: result) }
                )
              }
            }
          }
        }
      }
    }
  }
}


