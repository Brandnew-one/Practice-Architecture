//
//  Router.swift
//  Ex-1
//
//  Created by Bran on 2023/01/07.
//

import Foundation

import Alamofire

// MARK: - Build URLRequest
protocol RouterProtocol: URLRequestConvertible {
  var baseURL: URL { get }
  var endPoint: String { get }
  var method: HTTPMethod { get }
  var header: HTTPHeaders { get }
  var query: [URLQueryItem] { get }
  var parameters: Parameters { get }

  func asURLRequest() throws -> URLRequest
}
