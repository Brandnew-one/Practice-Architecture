//
//  RootTabView.swift
//  Ex-1
//
//  Created by Bran on 2023/01/15.
//

import SwiftUI

struct RootTabView: View {
  @State
  var tabIndex: TabItem = .search

  @EnvironmentObject
  var appState: AppState

  var body: some View {
    tabView
  }
}

extension RootTabView {
  @ViewBuilder
  var tabView: some View {
    TabView(selection: $tabIndex) {
      MediaListView(viewModel: appState.di.mediaListViewModel())
        .tag(TabItem.search)
        .tabItem {
          TabItem.search.image

          Text(TabItem.search.title)
        }

      SavedMediaListView(viewModel: appState.di.savedMediaListViewModel())
        .tag(TabItem.saved)
        .tabItem {
          TabItem.saved.image

          Text(TabItem.saved.title)
        }
    }
  }
}
