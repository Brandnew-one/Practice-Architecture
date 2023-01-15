//
//  APPContainer.swift
//  Ex-1
//
//  Created by Bran on 2023/01/15.
//

import Foundation

protocol AppContainer {
  func mediaListViewModel() -> MediaListViewModel
  func mediaDetailViewModel(_ media: Media) -> MediaDetailViewModel
}
