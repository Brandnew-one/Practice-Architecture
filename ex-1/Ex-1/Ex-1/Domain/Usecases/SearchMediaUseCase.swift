//
//  SearchMediaUseCase.swift
//  Ex-1
//
//  Created by Bran on 2022/12/25.
//

import Combine
import Foundation

protocol SearchMediaUseCase {
  func excute(
    query: String,
    page: Int
  ) -> AnyPublisher<MediaPage, Error>
}

final class DefaultSearchMediaUseCase: SearchMediaUseCase {
  private let mediaRepository: MediaRepository

  init(mediaRepository: MediaRepository) {
    self.mediaRepository = mediaRepository
  }

  func excute(
    query: String,
    page: Int
  ) -> AnyPublisher<MediaPage, Error> {
    mediaRepository.fetchMedia(query: query, page: page)
  }
}
