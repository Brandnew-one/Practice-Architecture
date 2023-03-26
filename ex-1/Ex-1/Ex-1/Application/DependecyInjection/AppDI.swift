//
//  AppDI.swift
//  Ex-1
//
//  Created by Bran on 2023/01/08.
//

import Foundation

final class AppDI: AppDIInterface {
  lazy var mediaUsecase: SearchMediaUseCase = {
    let mediaRepository: MediaRepository = MediaRepositoryImpl()
    let mediaDetailRepository: MediaDetailRepository = MediaDetailRepositoryImpl(RealmDataStorage.shared)
    return DefaultSearchMediaUseCase(
      mediaRepository: mediaRepository,
      mediaDetailRepository: mediaDetailRepository
    )
  }()

  func mediaListViewModel() -> MediaListViewModel {
    return MediaListViewModel(searchMediaUsecase: mediaUsecase)
  }

  func savedMediaListViewModel() -> SavedMediaListViewModel {
    return SavedMediaListViewModel(searchMediaUsecase: mediaUsecase)
  }

  func mediaDetailViewModel(
    _ media: Media
  ) -> MediaDetailViewModel {
    return MediaDetailViewModel(
      media: media,
      usecase: mediaUsecase
    )
  }
}
