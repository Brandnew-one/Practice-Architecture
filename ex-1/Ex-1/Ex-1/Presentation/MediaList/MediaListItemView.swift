//
//  MediaListItemView.swift
//  Ex-1
//
//  Created by Bran on 2022/12/25.
//

import SwiftUI

import Kingfisher

struct MediaListItemView: View {
  fileprivate let media: Media

  init(media: Media) {
    self.media = media
  }

  var body: some View {
    HStack {
      KFImage(URL(string: media.posterURL))
        .resizable()
        .frame(width: 80, height: 100)

      VStack(alignment: .leading, spacing: 2) {
        Text(media.name)
          .font(.title3)

        Text(media.overview)
          .multilineTextAlignment(.leading)
          .foregroundColor(.gray)
          .font(.body)
      }
    }
    .frame(height: 100)
    .frame(maxWidth: .infinity)
    .padding()
    .background(Color.init(.systemGray6))
    .cornerRadius(25)
  }
}

struct MediaListItemView_Previews: PreviewProvider {
  static var previews: some View {
    MediaListItemView(
      media:
        Media(
          name: "웬즈데이",
          originName: "Wednesday",
          posterURL: "https://image.tmdb.org/t/p/original/tNWCukAMubqisamYURvo5jw61As.jpg",
          overview: "똑똑하고 비꼬는 것에 도가 튼 웬즈데이 아담스. 암울함을 풍기는 그녀가 네버모어 아카데미에서 연쇄 살인 사건을 조사하기 시작한다. 새 친구도 사귀고, 앙숙도 만들며",
          rating: 8.762
        )
    )
  }
}
