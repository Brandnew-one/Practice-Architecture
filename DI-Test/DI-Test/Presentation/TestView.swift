//
//  TestView.swift
//  DI-Test
//
//  Created by Bran on 2023/04/05.
//

import SwiftUI

struct TestView: View {
  @EnvironmentObject
  var appState: AppState

  var body: some View {
    VStack {
      NavigationLink(
        destination: { TestView2() },
        label: {
          Text("Push")
        }
      )

      Button(
        action: {
          appState.count += 1
        },
        label: {
          Text("up")
        }
      )
    }
  }
}

struct TestView2: View {
  @EnvironmentObject
  var appState: AppState

  var body: some View {
    Text("\(appState.count)")
  }
}
