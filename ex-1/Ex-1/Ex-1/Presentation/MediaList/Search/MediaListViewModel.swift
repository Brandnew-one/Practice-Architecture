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
    var toastMessage: String = ""
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
      .flatMap { [weak self] search -> AnyPublisher<MediaPage, Never> in
        guard let self = self else {
          return Just(MediaPage(
            page: -1,
            totalPages: -1,
            medias: [])
          ).eraseToAnyPublisher()
        }
        // Error받았을 때 Never보내줘야 돼서 빈값이나 임의의 Entity를 보내줘야만 함
        return self.searchMediaUsecase.tvExcute(query: search, page: 1)
          .catch { err in
            if let err = err as? BranError {
              switch err {
              case .unknown:
                print("UnKnown Error")
              case .internalError:
                print("Server Error")
              case .decodeError:
                print("Decode Error")
              }
            }
            return Empty(outputType: MediaPage.self, failureType: Never.self)
          }
          .eraseToAnyPublisher()
      }
      .map { $0.medias }
      .sink(receiveValue: { [weak self] in
        guard let self = self else { return }
        self.output.medias = $0
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
