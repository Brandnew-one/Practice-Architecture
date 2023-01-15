//
//  Media.swift
//  Ex-1
//
//  Created by Bran on 2022/12/25.
//

import Foundation

// TODO: - Error를 Domain Layer에서 정의하면 되지않을까?
struct Media: Equatable, Identifiable {
  let id: Int
  let name: String
  let originName: String
  let posterURL: String
  let overview: String
  let rating: Double
}

struct MediaPage: Equatable {
  let page: Int
  let totalPages: Int
  let medias: [Media]
}
