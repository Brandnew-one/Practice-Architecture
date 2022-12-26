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
      LazyVStack {
        ForEach(viewModel.output.medias, id: \.id) {
          MediaListItemView(media: $0)
        }
      }
      .searchable(text: $viewModel.input.searchMediaSub.value)
    }
  }
}
