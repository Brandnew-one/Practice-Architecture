//
//  BranError.swift
//  Ex-1
//
//  Created by Bran on 2023/01/25.
//

import Foundation

enum BranError: Error {
  case unknown
  case decodeError
  case internalError

  var message: String {
    switch self {
    case .unknown:
      return "알 수 없는 에러입니다."
    case .decodeError:
      return "디코딩 에러입니다."
    case .internalError:
      return "서버 문제입니다. 잠시후 다시 시도해주세요"
    }
  }
}
