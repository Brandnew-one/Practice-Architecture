//
//  ViewModelType.swift
//  Ex-1
//
//  Created by Bran on 2022/12/26.
//

import Combine
import Foundation

protocol ViewModelType: ObservableObject {
  associatedtype Input // Struct
  associatedtype Action
  associatedtype Output // Struct

  var cancellables: Set<AnyCancellable> { get }
  var input: Input { get }
  var output: Output { get  set } // private(set)
  func action(_ action: Action)
  func transform()
}
