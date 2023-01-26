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
    fileprivate let navigationSub = PassthroughSubject<Media, Never>()
  }

  enum Action {
    case searchButtonTapped
    case navigationTapped(Media)
  }

  func action(_ action: Action) {
    switch action {
    case .searchButtonTapped:
      input.searchButtonSub.send()
    case .navigationTapped(let media):
      input.navigationSub.send(media)
    }
  }

  struct Output {
    var medias: [Media] = []
    var isNavigationShow: Bool = false
    var selectedMedia: Media?
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
      .debounce(for: 0.5, scheduler: RunLoop.main)
      .flatMap { [weak self] search -> AnyPublisher<Result<MediaPage, BranError>, Never> in
        guard let self = self else {
          return Just(Result.failure(BranError.unknown)).eraseToAnyPublisher()
        }
        return self.searchMediaUsecase.tvExcute(query: search, page: 1)
      }
      .sink(receiveValue: { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let mediaPage):
          self.output.medias = mediaPage.medias
        case .failure(let err):
          print(err.message)
        }
      })
      .store(in: &cancellables)

    input.navigationSub
      .sink(receiveValue: { [weak self] in
        guard let self = self else { return }
        self.output.selectedMedia = $0
        self.output.isNavigationShow = true
      })
      .store(in: &cancellables)
  }
}
