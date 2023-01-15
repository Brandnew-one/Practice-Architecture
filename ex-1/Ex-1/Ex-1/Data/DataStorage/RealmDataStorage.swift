//
//  RealmDataStorage.swift
//  Ex-1
//
//  Created by Bran on 2023/01/15.
//

import Foundation

import RealmSwift

// MARK: - Realm DB를 2개 써야하는 상황이 오면 어떻게 처리해야 할까?
/// default realm 말고 여러가지를 사용해야 하는건가?
final class RealmDataStorage {
  static let shared = RealmDataStorage()
  private(set) var realm: Realm?

  private init() {
    do {
      realm = try Realm()
    } catch {
      print("Error opening default realm", error)
    }
  }
}

extension RealmDataStorage {
  func load() -> [MediaRealmDTO] {
    if let realm = realm {
      let mediaList = realm.objects(MediaRealmDTO.self)
      return Array(mediaList)
    } else {
      return []
    }
  }

  func find(_ media: MediaRealmDTO) -> Bool {
    if let realm = realm {
      do {
        try realm.write {
          if let _ = realm.objects(MediaRealmDTO.self).filter("id == \(media.id)").first {
            print("이미 존재")
            return true
          } else {
            return false
          }
        }
      } catch {
        print("Error adding media to realm", error)
        return false
      }
    }
    return false
  }

  func save(_ media: MediaRealmDTO) {
    if let realm = realm {
      do {
        try realm.write {
          realm.add(media)
        }
      } catch {
        print("Error adding media to realm", error)
      }
    }
  }

  func delete(_ media: MediaRealmDTO) {
    if let realm = realm {
      if let delMedia = realm.object(
        ofType: MediaRealmDTO.self,
        forPrimaryKey: media.id
      ) {
        do {
          try realm.write {
            realm.delete(delMedia)
          }
        } catch {
          print("Could not delete media", error)
        }
      }
    }
  }
}
