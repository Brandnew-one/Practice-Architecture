//
//  Button + Extension.swift
//  Ex-1
//
//  Created by Bran on 2022/12/25.
//

import SwiftUI

private struct ButtonWrapper: ViewModifier {
  let action: () -> Void

  init(action: @escaping () -> Void) {
    self.action = action
  }

  func body(content: Content) -> some View {
    Button(
      action: action,
      label: { content }
    )
  }
}

extension View {
  public func wrapToButton(
    action: @escaping () -> Void
  ) -> some View {
    modifier(ButtonWrapper(action: action))
  }
}
