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

  let appContainer: AppContainer

  var body: some View {
    NavigationView {
      ScrollView {
        LazyVStack {
          ForEach(viewModel.output.medias, id: \.id) { media in
            NavigationLink(
              destination: {
                NavigationLazyView(
                  MediaDetailView(
                    viewModel: appContainer.mediaDetailViewModel(media)
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

