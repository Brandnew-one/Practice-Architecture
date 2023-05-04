//
//  MovieDetailView.swift
//  TCA-MovieSearch
//
//  Created by Bran on 2023/05/04.
//

import SwiftUI

import ComposableArchitecture
import Kingfisher

struct MovieDetailView: View {
  private let deviceWidth = UIScreen.main.bounds.width
  let store: StoreOf<MovieDetailReducer>

  var body: some View {
    WithViewStore(store) { viewStore in
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 20) {
          KFImage(URL(string: "viewModel.output.posterURL"))
            .resizable()
            .frame(width: deviceWidth, height: deviceWidth)

          titleSection

          ratingSection

          overviewSection
        }
      }
      .navigationTitle("viewModel.output.navigationTitle")
  //    .toolbar {
  //      ToolbarItem(placement: .navigationBarTrailing) {
  //        if viewModel.output.isSaved {
  //          Image(systemName: "doc.fill")
  //            .wrapToButton { viewModel.action(.saveButtonTapped) }
  //        } else {
  //          Image(systemName: "doc")
  //            .wrapToButton { viewModel.action(.saveButtonTapped) }
  //        }
  //      }
  //    }
    }
  }
}

extension MovieDetailView {
  @ViewBuilder
  var titleSection: some View {
    Text("viewModel.output.title")
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

      Text("viewModel.output.rating")
        .fontWeight(.semibold)
    }
  }

  @ViewBuilder
  var overviewSection: some View {
    Text("viewModel.output.overView")
      .font(.body)
      .fontWeight(.medium)
  }
}
