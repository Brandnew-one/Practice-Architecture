//
//  NetworkLogger.swift
//  Ex-1
//
//  Created by Bran on 2023/01/07.
//

import Foundation

import Alamofire

final class NetworkLogger: EventMonitor {
  let queue = DispatchQueue(label: "BurritoWallet_APiLogger")

  // Event called when any type of Request is resumed.
  func requestDidResume(_ request: Request) {
#if DEBUG
    let debugDisc = """
                    Resuming:
                    <URL: \(request.request?.method?.rawValue ?? "")> \(request.request?.url?.description ?? "")
                    parameter: \(request.request?.httpBody?.toPrettyPrintedString ?? "nil")
                    header: \(request.request?.headers.dictionary)
                    """
    print(debugDisc)
#endif
  }
  // Event called whenever a DataRequest has parsed a response.
  func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
#if DEBUG
    let debugDisc = """
                    Finished:
                    <URL: \(response.request?.method?.rawValue ?? "")> \(response.request?.url?.description ?? "")
                    code: \(response.response?.statusCode ?? 0)
                    ========== Response DATA ==========
                    \(response)
                    ========== Response END ===========

                    """
    print(debugDisc)
#endif
  }
}

extension Data {
  var toPrettyPrintedString: String? {
    guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
          let data = try? JSONSerialization.data(withJSONObject: object, options: [.sortedKeys]),
          let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
    return prettyPrintedString as String
  }
}
// swiftlint:enable indentation_width

