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

// FIXME: - T.toDomain 타입을 반환하기 때문에 해당 메서드 사용불가
/// 중복되는 코드를 줄일 수 있는 방법 생각해보기
extension NetworkService {
  func request<T: Decodable>(
    _ request: URLRequestConvertible
  ) -> AnyPublisher<T, BranError> {
    return session.request(request)
      .validate(statusCode: 200..<300)
      .publishDecodable(type: T.self)
      .value()
      .mapError { _ in
        return BranError.unknown
      }
      .eraseToAnyPublisher()
  }
}
