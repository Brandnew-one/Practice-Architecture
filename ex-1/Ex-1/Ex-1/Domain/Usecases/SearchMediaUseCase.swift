//
//  SearchMediaUseCase.swift
//  Ex-1
//
//  Created by Bran on 2022/12/25.
//

import Combine
import Foundation

// MARK: - 프로토콜로 따로 나눌 필요가 있을까?
/// Usecase 없이 Testable하게 작업 할 수 있어서?
protocol SearchMediaUseCase {
  // MARK: - API Logic
  func movieExcute(
    query: String,
    page: Int
  ) -> AnyPublisher<MediaPage, Error>

  func tvExcute(
    query: String,
    page: Int
  ) -> AnyPublisher<Result<MediaPage, BranError>, Never>

  // MARK: - DB Logic
  func fetchMediaList() -> [Media]

  func addMedia(_ media: Media)

  func delMedia(_ media: Media)

  func findMedia(_ media: Media) -> Bool
}

final class DefaultSearchMediaUseCase: SearchMediaUseCase {
  private let mediaRepository: MediaRepository
  private let mediaDetailRepository: MediaDetailRepository

  init(
    mediaRepository: MediaRepository,
    mediaDetailRepository: MediaDetailRepository
  ) {
    self.mediaRepository = mediaRepository
    self.mediaDetailRepository = mediaDetailRepository
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
  ) -> AnyPublisher<Result<MediaPage, BranError>, Never> {
    mediaRepository.fetchTv(query: query, page: page)
  }

  func findMedia(_ media: Media) -> Bool {
    mediaDetailRepository.findMedia(media)
  }

  func fetchMediaList() -> [Media] {
    mediaDetailRepository.fetchMedias()
  }

  func addMedia(_ media: Media) {
    mediaDetailRepository.addMedia(media)
  }

  func delMedia(_ media: Media) {
    mediaDetailRepository.delMedia(media)
  }
}
