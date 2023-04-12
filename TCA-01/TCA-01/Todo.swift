//
//  Todo.swift
//  TCA-01
//
//  Created by Bran on 2023/04/12.
//

import Foundation

// MARK: - Entity(=DTO)
struct Todo: Codable, Identifiable, Equatable {
  let id: Int
  let userId: Int
  let title: String
  let completed: Bool
}
