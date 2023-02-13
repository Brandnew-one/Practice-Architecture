//
//  AppState.swift
//  Ex-1
//
//  Created by Bran on 2023/02/13.
//

import Combine
import Foundation

final class AppState: ObservableObject {
  let di: AppDIInterface

  init(di: AppDIInterface) {
    self.di = di
  }
}
