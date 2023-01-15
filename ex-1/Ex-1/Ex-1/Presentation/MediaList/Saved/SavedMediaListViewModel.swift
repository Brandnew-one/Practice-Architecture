//
//  SavedMediaListViewModel.swift
//  Ex-1
//
//  Created by Bran on 2023/01/16.
//

import Combine
import Foundation

final class SavedMediaListViewModel: ObservableObject {
  private let usecase: SearchMediaUseCase

  enum Action {
    case refresh
  }

  func action(_ action: Action) {
    switch action {
    case .refresh:
      refresh()
    }
  }

  struct Output {
    var medias: [Media] = []
  }

  @Published var output = Output()
  var cancellables = Set<AnyCancellable>()

  init(searchMediaUsecase: SearchMediaUseCase) {
    self.usecase = searchMediaUsecase
    self.output.medias = usecase.fetchMediaList()
  }
}

extension SavedMediaListViewModel {
  func refresh() {
    output.medias = usecase.fetchMediaList()
  }
}

