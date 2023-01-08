//
//  MediaRequestDTO.swift
//  Ex-1
//
//  Created by Bran on 2023/01/07.
//

import Foundation

struct MediaRequestDTO {
  let query: String
  let page: Int

  func toDic() -> [String: Any] {
    let param: [String: Any] = [
      "query": query,
      "page": page
    ]
    return param
  }

  func toQuery() -> [URLQueryItem] {
    return [
      URLQueryItem(name: "query", value: query),
      URLQueryItem(name: "page", value: "1"),
      URLQueryItem(name: "api_key", value: "169881821286bdcac4cce29506f8782a"),
      URLQueryItem(name: "language", value: "ko-KR")
    ]
  }
}
