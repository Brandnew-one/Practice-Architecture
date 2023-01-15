//
//  NavigationLazyView.swift
//  Ex-1
//
//  Created by Bran on 2023/01/15.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
  let build: () -> Content
  init(_ build: @autoclosure @escaping () -> Content) {
    self.build = build
  }
  var body: Content {
    build()
  }
}
