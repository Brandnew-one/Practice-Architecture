//
//  AppDIInterface.swift
//  Ex-1
//
//  Created by Bran on 2023/02/13.
//

import Foundation

protocol AppDIInterface {
  func mediaListViewModel() -> MediaListViewModel
  func savedMediaListViewModel() -> SavedMediaListViewModel
  func mediaDetailViewModel(_ media: Media) -> MediaDetailViewModel
}
