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

  let appContainer: AppContainer

  var body: some View {
    tabView
  }
}

extension RootTabView {
  @ViewBuilder
  var tabView: some View {
    TabView(selection: $tabIndex) {
      MediaListView(viewModel: appContainer.mediaListViewModel(), appContainer: appContainer)
        .tag(TabItem.search)
        .tabItem {
          TabItem.search.image

          Text(TabItem.search.title)
        }

      SavedMediaListView(viewModel: appContainer.savedMediaListViewModel(), appContainer: appContainer)
        .tag(TabItem.saved)
        .tabItem {
          TabItem.saved.image

          Text(TabItem.saved.title)
        }
    }
  }
}
