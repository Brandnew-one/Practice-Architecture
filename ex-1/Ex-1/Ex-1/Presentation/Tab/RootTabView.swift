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

  var body: some View {
    tabView
  }
}

extension RootTabView {
  @ViewBuilder
  var tabView: some View {
    TabView(selection: $tabIndex) {
      Color.green
        .tag(TabItem.search)
        .tabItem {
          TabItem.search.image

          Text(TabItem.search.title)
        }

      Color.yellow
        .tag(TabItem.saved)
        .tabItem {
          TabItem.saved.image

          Text(TabItem.saved.title)
        }
    }
  }
}

struct RootTabView_Previews: PreviewProvider {
  static var previews: some View {
    RootTabView()
  }
}
