//
//  MediaDetailView.swift
//  Ex-1
//
//  Created by Bran on 2023/01/07.
//

import SwiftUI

import Kingfisher

struct MediaDetailView: View {
  @ObservedObject
  var viewModel: MediaDetailViewModel

  private let deviceWidth = UIScreen.main.bounds.width

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: 20) {
        KFImage(URL(string: viewModel.output.posterURL))
          .resizable()
          .frame(width: deviceWidth, height: deviceWidth)

        titleSection

        ratingSection

        overviewSection
      }
    }
    .navigationTitle(viewModel.output.navigationTitle)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        if viewModel.output.isSaved {
          Image(systemName: "doc.fill")
            .wrapToButton { viewModel.action(.saveButtonTapped) }
        } else {
          Image(systemName: "doc")
            .wrapToButton { viewModel.action(.saveButtonTapped) }
        }
      }
    }
  }
}

extension MediaDetailView {
  @ViewBuilder
  var titleSection: some View {
    Text(viewModel.output.title)
      .font(.title)
      .fontWeight(.semibold)
  }

  @ViewBuilder
  var ratingSection: some View {
    HStack {
      Image(systemName: "star.fill")
        .resizable()
        .renderingMode(.template)
        .foregroundColor(.yellow)
        .frame(width: 30, height: 30)

      Text(viewModel.output.rating)
        .fontWeight(.semibold)
    }
  }

  @ViewBuilder
  var overviewSection: some View {
    Text(viewModel.output.overView)
      .font(.body)
      .fontWeight(.medium)
  }
}
