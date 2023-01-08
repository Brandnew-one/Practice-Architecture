//
//  MediaRouter.swift
//  Ex-1
//
//  Created by Bran on 2023/01/07.
//

import Foundation

import Alamofire

enum MediaSearchRouter: RouterProtocol {
  case searchMovie(mediaRequestDTO: MediaRequestDTO)
  case searchTV(mediaRequestDTO: MediaRequestDTO)

  var baseURL: URL {
    switch self {
    case .searchMovie:
      return URL(string: "https://api.themoviedb.org/3/search/")!
    case .searchTV:
      return URL(string: "https://api.themoviedb.org/3/search/")!
    }
  }

  var endPoint: String {
    switch self {
    case .searchMovie:
      return "movie"
    case .searchTV:
      return "tv"
    }
  }

  var method: Alamofire.HTTPMethod {
    switch self {
    case .searchMovie:
      return .get
    case .searchTV:
      return .get
    }
  }

  var header: Alamofire.HTTPHeaders {
    switch self {
    default:
      let httpHeader: HTTPHeaders = []
      return httpHeader
    }
  }

  var query: [URLQueryItem] {
    switch self {
    case .searchMovie(let mediaRequestDTO):
      return mediaRequestDTO.toQuery()
    case .searchTV(let mediaRequestDTO):
      return mediaRequestDTO.toQuery()
    }
  }

  var parameters: Alamofire.Parameters {
    switch self {
    case .searchMovie:
      let param = Parameters()
      return param
    case .searchTV:
      let param = Parameters()
      return param
    }
  }

  func asURLRequest() throws -> URLRequest {
    let urlString = baseURL.appendingPathComponent(endPoint).absoluteString
    var urlComponets = URLComponents(string: urlString)
    urlComponets?.queryItems = query

    if let url = urlComponets?.url {
      var request = URLRequest(url: url)
      request.method = method
      if method == .post || method == .patch {
        request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
      }
      return request
    } else {
      print("Query 추가 실패")
      throw AFError.invalidURL(url: baseURL.appendingPathComponent(endPoint))
    }
  }
}
