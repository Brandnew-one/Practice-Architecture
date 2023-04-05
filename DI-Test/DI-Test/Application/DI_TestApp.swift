//
//  DI_TestApp.swift
//  DI-Test
//
//  Created by Bran on 2023/04/05.
//

import SwiftUI

@main
struct DI_TestApp: App {
  var body: some Scene {
    let appDI = AppState()
    WindowGroup {
      RootView()
        .environmentObject(appDI)
    }
  }
}
