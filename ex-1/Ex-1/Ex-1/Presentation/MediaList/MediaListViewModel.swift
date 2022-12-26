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
    input.searchButtonSub
      .throttle(for: 0.1, scheduler: RunLoop.main, latest: false)
      .flatMap { [weak self] _ -> AnyPublisher<MediaPage, Never> in
        guard let self = self else {
          return Just(MediaPage(page: -1, totalPages: -1, medias: [])).eraseToAnyPublisher()
        }
        return self.searchMediaUsecase.excute(query: self.input.searchMediaSub.value, page: 1)
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
