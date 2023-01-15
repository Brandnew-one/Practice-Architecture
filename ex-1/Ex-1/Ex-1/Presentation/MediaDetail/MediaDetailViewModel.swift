//
//  MediaDetailViewModel.swift
//  Ex-1
//
//  Created by Bran on 2023/01/07.
//

import Combine
import Foundation

final class MediaDetailViewModel: ObservableObject {
  private let media: Media
  private let usecase: SearchMediaUseCase

  struct Input {
    fileprivate let saveSub = PassthroughSubject<Void, Never>()
  }

  enum Action {
    case saveButtonTapped
  }

  func action(_ action: Action) {
    switch action {
    case .saveButtonTapped:
      input.saveSub.send()
    }
  }

  struct Output {
    var navigationTitle: String = ""
    var title: String = ""
    var posterURL: String = ""
    var rating: String = ""
    var overView: String = ""
    var isSaved: Bool = false
  }

  var input: Input = Input()
  @Published var output: Output = Output()
  var cancellables = Set<AnyCancellable>()

  init(
    media: Media,
    usecase: SearchMediaUseCase
  ) {
    self.media = media
    self.usecase = usecase

    mediaToOutput()
    transform()
  }

  func transform() {
    input.saveSub
      .throttle(for: 0.1, scheduler: RunLoop.main, latest: false)
      .print()
      .sink(receiveValue: { [weak self] in
        guard let self = self else { return }
        if self.output.isSaved {
          print("----Del-----")
          self.usecase.delMedia(self.media)
          self.output.isSaved = false
        } else {
          print("----Save-----")
          self.usecase.addMedia(self.media)
          self.output.isSaved = true
        }
      })
      .store(in: &cancellables)
  }
}

extension MediaDetailViewModel {
  private func mediaToOutput() {
    output.navigationTitle = media.originName
    output.title = media.name
    output.posterURL = media.posterURL
    output.rating = "\(media.rating.ratingType)"
    output.overView = media.overview
    output.isSaved = usecase.findMedia(media)
    print("isSaved:", output.isSaved)
    print("isSaved:", usecase.findMedia(media))
  }
}
