//
//  AppDI.swift
//  Ex-1
//
//  Created by Bran on 2023/01/08.
//

import Foundation

final class AppDI: AppContainer {
  static let shared = AppDI()
  private init() { }

  func mediaListViewModel() -> MediaListViewModel {
    let mediaRepository: MediaRepository = MediaRepositoryImpl()
    let mediaDetailRepository: MediaDetailRepository = MediaDetailRepositoryImpl(RealmDataStorage.shared)

    let usecase: DefaultSearchMediaUseCase = DefaultSearchMediaUseCase(
      mediaRepository: mediaRepository,
      mediaDetailRepository: mediaDetailRepository
    )

    return MediaListViewModel(searchMediaUsecase: usecase)
  }

  func mediaDetailViewModel(_ media: Media) -> MediaDetailViewModel {
    let mediaRepository: MediaRepository = MediaRepositoryImpl()
    let mediaDetailRepository: MediaDetailRepository = MediaDetailRepositoryImpl(RealmDataStorage.shared)

    let usecase: DefaultSearchMediaUseCase = DefaultSearchMediaUseCase(
      mediaRepository: mediaRepository,
      mediaDetailRepository: mediaDetailRepository
    )

    return MediaDetailViewModel(media: media, usecase: usecase)
  }
}
