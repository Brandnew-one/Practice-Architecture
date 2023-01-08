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

  var body: some View {
    NavigationView {
      ScrollView {
        LazyVStack {
          ForEach(viewModel.output.medias, id: \.id) { media in
            NavigationLink(
              destination: {
                MediaDetailView(viewModel: MediaDetailViewModel(media: media))
              },
              label: { MediaListItemView(media: media) }
            )
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
