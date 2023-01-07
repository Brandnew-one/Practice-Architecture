//
//  MediaDetailViewModel.swift
//  Ex-1
//
//  Created by Bran on 2023/01/07.
//

import Combine
import Foundation

final class MediaDetailViewModel: ObservableObject {
  struct Output {
    var navigationTitle: String = ""
    var title: String = ""
    var posterURL: String = ""
    var rating: String = ""
    var overView: String = ""
  }
  @Published var output: Output = Output()
  var cancellables = Set<AnyCancellable>()

  init(media: Media) {
    self.output.navigationTitle = media.originName
    self.output.title = media.name
    self.output.posterURL = media.posterURL
    self.output.rating = "\(media.rating.ratingType)"
    self.output.overView = media.overview
  }
}
