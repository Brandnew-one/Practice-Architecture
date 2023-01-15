//
//  TabItem.swift
//  Ex-1
//
//  Created by Bran on 2023/01/15.
//

import SwiftUI

enum TabItem: Hashable {
  case search
  case saved

  var title: String {
    switch self {
    case .search:
      return "search"
    case .saved:
      return "save"
    }
  }

  var image: Image {
    switch self {
    case .search:
      return Image(systemName: "magnifyingglass")
    case .saved:
      return Image(systemName: "archivebox")
    }
  }
}
