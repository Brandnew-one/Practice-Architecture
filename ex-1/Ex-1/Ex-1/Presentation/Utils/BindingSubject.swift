//
//  BindingSubject.swift
//  Ex-1
//
//  Created by Bran on 2022/12/26.
//

import Combine
import Foundation

struct BindingSubject<T> {
  let subject = PassthroughSubject<T, Never>()
  var value: T {
    didSet { subject.send(value) }
  }
}
