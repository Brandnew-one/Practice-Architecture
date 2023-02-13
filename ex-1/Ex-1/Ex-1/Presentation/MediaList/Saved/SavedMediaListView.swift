//
//  SavedMediaListView.swift
//  Ex-1
//
//  Created by Bran on 2023/01/16.
//

import SwiftUI

struct SavedMediaListView: View {
  @StateObject
  var viewModel: SavedMediaListViewModel

  @EnvironmentObject
  var appState: AppState

  var body: some View {
    NavigationView {
      ScrollView {
        LazyVStack {
          ForEach(viewModel.output.medias, id: \.id) { media in
            NavigationLink(
              destination: {
                NavigationLazyView(
                  MediaDetailView(
                    viewModel: appState.di.mediaDetailViewModel(media)
                  )
                )
              },
              label: {
                MediaListItemView(media: media)
              }
            )
          }
        }
        .padding(.top, 20)
        .padding([.leading, .trailing], 12)
      }
      .navigationTitle("Saved Media")
      .navigationBarTitleDisplayMode(.inline)
      .onAppear { viewModel.action(.refresh) }
    }
  }
}

