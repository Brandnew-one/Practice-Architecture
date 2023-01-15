//
//  MediaRealmDTO.swift
//  Ex-1
//
//  Created by Bran on 2023/01/15.
//

import Foundation

import RealmSwift

// MARK: - Entity로 부터 init? or DTO로 부터 init?
final class MediaRealmDTO: Object, ObjectKeyIdentifiable {
  @Persisted(primaryKey: true) var id: Int
  @Persisted var title: String
  @Persisted var originTitle: String
  @Persisted var posterPath: String
  @Persisted var rating: Double
  @Persisted var overview: String

  convenience init(media: Media) {
    self.init()
    self.id = media.id
    self.title = media.name
    self.originTitle = media.originName
    self.posterPath = media.posterURL
    self.rating = media.rating
    self.overview = media.overview
  }
}

extension MediaRealmDTO {
  func toDomain() -> Media {
    return .init(
      id: id,
      name: title,
      originName: originTitle,
      posterURL: posterPath,
      overview: overview,
      rating: rating
    )
  }
}
