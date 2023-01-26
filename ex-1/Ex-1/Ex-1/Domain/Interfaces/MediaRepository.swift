//
//  MediaRepository.swift
//  Ex-1
//
//  Created by Bran on 2022/12/25.
//

import Combine
import Foundation

protocol MediaRepository {
  func fetchTv(
    query: String,
    page: Int
  ) -> AnyPublisher<Result<MediaPage, BranError>, Never>

  func fetchMovie(
    query: String,
    page: Int
  ) -> AnyPublisher<MediaPage, Error>
}
