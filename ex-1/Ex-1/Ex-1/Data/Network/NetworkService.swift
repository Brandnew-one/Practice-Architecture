//
//  NetworkService.swift
//  Ex-1
//
//  Created by Bran on 2023/01/07.
//

import Combine
import Foundation

import Alamofire

final class NetworkService {
  public static let shared = NetworkService()

  let monitors = [NetworkLogger()] as [EventMonitor]
  var session: Session

  private init() {
    session = Session(eventMonitors: monitors)
  }
}

extension NetworkService {
  func request<T: Decodable>(
    _ request: URLRequestConvertible
  ) -> AnyPublisher<T, AFError> {
    return session.request(request)
      .validate(statusCode: 200..<300)
      .publishDecodable(type: T.self)
      .value()
  }
}
