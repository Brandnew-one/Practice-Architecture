//
//  MediaListView.swift
//  Ex-1
//
//  Created by Bran on 2022/12/25.
//

import SwiftUI

struct MediaListView: View {
  @StateObject
  var viewModel: MediaListViewModel

  @EnvironmentObject
  var appState: AppState

  var body: some View {
    NavigationView {
      ScrollView {
        LazyVStack {
          // Empty View
          NavigationLink(
            isActive: $viewModel.output.isNavigationShow,
            destination: {
              if let media = viewModel.output.selectedMedia {
                NavigationLazyView(
                  MediaDetailView(
                    viewModel: appState.di.mediaDetailViewModel(media)
                  )
                )
              }
            },
            label: { }
          )
          // List Cell Item
          ForEach(viewModel.output.medias, id: \.id) { media in
            MediaListItemView(media: media)
              .wrapToButton { viewModel.action(.navigationTapped(media)) }
          }
        }
        .padding(.top, 20)
        .padding([.leading, .trailing], 12)
      }
      .navigationTitle("TV Search")
      .navigationBarTitleDisplayMode(.inline)
      .searchable(text: $viewModel.input.searchMediaSub.value)
    }
  }
}
