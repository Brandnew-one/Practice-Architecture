//
//  Ex_1App.swift
//  Ex-1
//
//  Created by Bran on 2022/12/25.
//

import SwiftUI

@main
struct Ex_1App: App {
  let appState = AppState(di: AppDI.shared)

  var body: some Scene {
    WindowGroup {
      RootTabView()
        .environmentObject(appState)
        .onAppear {
          print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path)
        }
    }
  }
}
