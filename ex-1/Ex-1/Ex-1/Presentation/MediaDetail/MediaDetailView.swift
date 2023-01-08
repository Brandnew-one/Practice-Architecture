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

struct MediaDetailView_Previews: PreviewProvider {
  static var previews: some View {
    MediaDetailView(
      viewModel: MediaDetailViewModel(
        media: Media(
          name: "웬즈데이",
          originName: "Wednesday",
          posterURL: "https://image.tmdb.org/t/p/original/tNWCukAMubqisamYURvo5jw61As.jpg",
          overview: "똑똑하고 비꼬는 것에 도가 튼 웬즈데이 아담스. 암울함을 풍기는 그녀가 네버모어 아카데미에서 연쇄 살인 사건을 조사하기 시작한다. 새 친구도 사귀고, 앙숙도 만들며",
          rating: 8.762
        )
      )
    )
  }
}



