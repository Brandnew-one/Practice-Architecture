//
//  AppDI.swift
//  Ex-1
//
//  Created by Bran on 2023/01/08.
//

import Foundation

final class AppDI {
  static let shared = AppDI()
  private init() { }

  func mediaListViewModel() -> MediaListViewModel {
    let repository: MediaRepository = MediaRepositoryImpl()
    let usecase: DefaultSearchMediaUseCase = DefaultSearchMediaUseCase(mediaRepository: repository)

    return MediaListViewModel(searchMediaUsecase: usecase)
  }
}
