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

            ForEach(viewStore.searchResult, id: \.self) { result in
              Text(result)
                .font(.largeTitle)
            }
          }
        }
      }
    }
  }
}


