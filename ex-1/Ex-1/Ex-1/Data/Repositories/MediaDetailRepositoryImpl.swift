//
//  MediaDetailRepositoryImpl.swift
//  Ex-1
//
//  Created by Bran on 2023/01/15.
//

import Foundation

final class MediaDetailRepositoryImpl {
  private let dataStorage: RealmDataStorage

  init(_ dataStorage: RealmDataStorage) {
    self.dataStorage = dataStorage
  }
}

extension MediaDetailRepositoryImpl: MediaDetailRepository {
  func fetchMedias() -> [Media] {
    dataStorage.load().map { $0.toDomain() }
  }

  func findMedia(_ media: Media) -> Bool {
    let mediaRealmDTO = MediaRealmDTO(media: media)
    return dataStorage.find(mediaRealmDTO)
  }

  func addMedia(_ media: Media) {
    let mediaRealmDTO = MediaRealmDTO(media: media)
    return dataStorage.save(mediaRealmDTO)
  }

  func delMedia(_ media: Media) {
    let mediaRealmDTO = MediaRealmDTO(media: media)
    return dataStorage.delete(mediaRealmDTO)
  }
}
