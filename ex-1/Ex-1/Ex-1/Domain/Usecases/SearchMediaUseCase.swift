//
//  SearchMediaUseCase.swift
//  Ex-1
//
//  Created by Bran on 2022/12/25.
//

import Combine
import Foundation

protocol SearchMediaUseCase {
  func movieExcute(
    query: String,
    page: Int
  ) -> AnyPublisher<MediaPage, Error>

  func tvExcute(
    query: String,
    page: Int
  ) -> AnyPublisher<MediaPage, Error>
}

final class DefaultSearchMediaUseCase: SearchMediaUseCase {
  private let mediaRepository: MediaRepository

  init(mediaRepository: MediaRepository) {
    self.mediaRepository = mediaRepository
  }

  func movieExcute(
    query: String,
    page: Int
  ) -> AnyPublisher<MediaPage, Error> {
    mediaRepository.fetchMovie(query: query, page: page)
  }

  func tvExcute(
    query: String,
    page: Int
  ) -> AnyPublisher<MediaPage, Error> {
    mediaRepository.fetchTv(query: query, page: page)
  }
}
