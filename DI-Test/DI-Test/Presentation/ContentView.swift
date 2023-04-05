//
//  ContentView.swift
//  DI-Test
//
//  Created by Bran on 2023/04/05.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject
  var appState: AppState

  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundColor(.accentColor)

      Text("Hello, world!")

      Text("\(appState.count)")
    }
    .padding()
  }
}
