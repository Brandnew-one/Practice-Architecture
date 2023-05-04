//
//  Movie.swift
//  TCA-MovieSearch
//
//  Created by Bran on 2023/05/04.
//

import Foundation

struct Movie: Equatable, Identifiable {
  let id: Int
  let name: String
  let originName: String
  let posterURL: String
  let overview: String
  let rating: Double
}

struct MoviePage: Equatable {
  let page: Int
  let totalPages: Int
  let medias: [Movie]
}
