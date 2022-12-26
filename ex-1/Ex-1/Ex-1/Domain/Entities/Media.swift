//
//  Media.swift
//  Ex-1
//
//  Created by Bran on 2022/12/25.
//

import Foundation

struct Media: Equatable, Identifiable {
  let id: UUID = UUID()
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
