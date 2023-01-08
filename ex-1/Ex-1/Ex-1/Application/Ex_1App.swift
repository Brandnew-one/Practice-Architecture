//
//  Ex_1App.swift
//  Ex-1
//
//  Created by Bran on 2022/12/25.
//

import SwiftUI

@main
struct Ex_1App: App {
  var body: some Scene {
    WindowGroup {
      MediaListView(viewModel: AppDI.shared.mediaListViewModel())
    }
  }
}
