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
          KFImage(URL(string: viewStore.selectedMovie.posterURL))
            .resizable()
            .frame(width: deviceWidth, height: deviceWidth)

          titleSection

          ratingSection

          overviewSection
        }
      }
      .navigationTitle(viewStore.selectedMovie.originName)
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

// TODO: - WithViewStore 안에 WithViewStore가 또 들어가도 되는건지?
extension MovieDetailView {
  @ViewBuilder
  var titleSection: some View {
    WithViewStore(store) { viewstore in
      Text(viewstore.selectedMovie.name)
        .font(.title)
        .fontWeight(.semibold)
    }
  }

  @ViewBuilder
  var ratingSection: some View {
    WithViewStore(store) { viewStore in
      HStack {
        Image(systemName: "star.fill")
          .resizable()
          .renderingMode(.template)
          .foregroundColor(.yellow)
          .frame(width: 30, height: 30)

        Text("\(viewStore.selectedMovie.rating)")
          .fontWeight(.semibold)
      }
    }
  }

  @ViewBuilder
  var overviewSection: some View {
    WithViewStore(store) { viewStore in
      Text(viewStore.selectedMovie.overview)
        .font(.body)
        .fontWeight(.medium)
    }
  }
}
