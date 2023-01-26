//
//  MediaRepositoryImpl.swift
//  Ex-1
//
//  Created by Bran on 2023/01/08.
//

import Combine
import Foundation

import Alamofire

final class MediaRepositoryImpl {
}

extension MediaRepositoryImpl: MediaRepository {
  func fetchTv(
    query: String,
    page: Int
  ) -> AnyPublisher<Result<MediaPage, BranError>, Never> {
    let requestDTO = MediaRequestDTO(query: query, page: page)

    return NetworkService.shared.session
      .request(MediaSearchRouter.searchTV(mediaRequestDTO: requestDTO))
      .validate(statusCode: 200..<300)
      .publishDecodable(type: MediaResponseDTO.self)
      .value()
      .mapError { _ in
        return BranError.decodeError
      }
      .tryMap {
        if $0.page == 1 {
          return Result.success($0.toDomain())
        } else {
          throw BranError.unknown
        }
      }
      .catch { err -> AnyPublisher<Result<MediaPage, BranError>, Never> in
        if let err = err as? BranError {
          return Just(Result.failure(err)).eraseToAnyPublisher()
        } else {
          return Just(Result.failure(BranError.unknown)).eraseToAnyPublisher()
        }
      }
      .eraseToAnyPublisher()
  }

  func fetchMovie(query: String, page: Int) -> AnyPublisher<MediaPage, Error> {
    let requestDTO = MediaRequestDTO(query: query, page: page)

    return NetworkService.shared.session
      .request(MediaSearchRouter.searchMovie(mediaRequestDTO: requestDTO))
      .validate(statusCode: 200..<300)
      .publishDecodable(type: MediaResponseDTO.self)
      .value()
      .map { $0.toDomain() }
      .mapError { $0 as Error }
      .eraseToAnyPublisher()
  }
}
