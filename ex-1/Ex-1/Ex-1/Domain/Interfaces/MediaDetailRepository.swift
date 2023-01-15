//
//  MediaDetailRepository.swift
//  Ex-1
//
//  Created by Bran on 2023/01/15.
//

import Foundation

protocol MediaDetailRepository {
  // MARK: - find saved Media
  func findMedia(_ media: Media) -> Bool

  // MARK: - 저장된 Media List
  func fetchMedias() -> [Media]

  // MARK: - Media 저장
  func addMedia(_ media: Media)

  // MARK: - Media 삭제
  func delMedia(_ media: Media)
}
