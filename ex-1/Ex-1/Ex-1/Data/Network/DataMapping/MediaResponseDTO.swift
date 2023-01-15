//
//  MediaResponseDTO.swift
//  Ex-1
//
//  Created by Bran on 2023/01/07.
//

import Foundation

struct MediaResponseDTO: Codable {
  let page: Int
  let totalPages: Int
  let medias: [MediaDTO]

  private enum CodingKeys: String, CodingKey {
    case page
    case totalPages = "total_pages"
    case medias = "results"
  }
}

extension MediaResponseDTO {
  struct MediaDTO: Codable {
    let id: Int?
    let title: String?
    let originTitle: String?
    let posterPath: String?
    let rating: Double?
    let overview: String?

    private enum CodingKeys: String, CodingKey {
      case id
      case title = "name"
      case originTitle = "original_name"
      case posterPath = "poster_path"
      case rating = "vote_average"
      case overview
    }
  }
}

// MARK: - Mappings to Domain(MediaPage)
extension MediaResponseDTO {
  func toDomain() -> MediaPage {
    return .init(
      page: page,
      totalPages: totalPages,
      medias: medias.map { $0.toDomain() }
    )
  }
}

// MARK: - Mappings to Domain(Media)
/// 여기서 API Call Error시 어떤 값을 보여줄 지 설정할 수 있음
extension MediaResponseDTO.MediaDTO {
  func toDomain() -> Media {
    return .init(
      id: id ?? -1,
      name: title ?? "",
      originName: originTitle ?? "",
      posterURL: ("https://image.tmdb.org/t/p/original") + (posterPath ?? "") ,
      overview: overview ?? "",
      rating: rating ?? 0.0
    )
  }
}
