//
//  MediaListViewModel.swift
//  Ex-1
//
//  Created by Bran on 2022/12/26.
//

import Combine
import Foundation

final class MediaListViewModel: ViewModelType {
  private let searchMediaUsecase: SearchMediaUseCase

  struct Input {
    var searchMediaSub = BindingSubject<String>(value: "")
    fileprivate let searchButtonSub = PassthroughSubject<Void, Never>()
  }

  enum Action {
    case searchButtonTapped
  }

  func action(_ action: Action) {
    switch action {
    case .searchButtonTapped:
      input.searchButtonSub.send()
    }
  }

  struct Output {
    var medias: [Media] = []
  }

  var input = Input()
  @Published var output = Output()
  var cancellables = Set<AnyCancellable>()

  init(searchMediaUsecase: SearchMediaUseCase) {
    self.searchMediaUsecase = searchMediaUsecase
    transform()
  }

  func transform() {
    input.searchMediaSub.subject
      .debounce(for: 0.2, scheduler: RunLoop.main)
      .flatMap { [weak self] search -> AnyPublisher<MediaPage, Never> in
        guard let self = self else {
          return Just(MediaPage(page: -1, totalPages: -1, medias: [])).eraseToAnyPublisher()
        }
        return self.searchMediaUsecase.tvExcute(query: search, page: 1)
          .replaceError(with: MediaPage(page: -1, totalPages: -1, medias: []))
          .eraseToAnyPublisher()
      }
      .map { $0.medias }
      .sink(receiveValue: { [weak self] in
        guard let self = self else { return }
        self.output.medias = $0
      })
      .store(in: &cancellables)
  }
}
