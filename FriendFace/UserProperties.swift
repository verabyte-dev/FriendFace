//
//  UserProperties.swift
//  FriendFace
//
//  Created by Jeffrey Williams on 3/30/20.
//  Copyright © 2020 Jeffrey Williams. All rights reserved.
//

import Foundation

/// Used to decode JSON data for User entity
struct UserProperties: Decodable, Hashable {
    let id: String
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: Date
    let tags: [String]
    let friends: [FriendProperties]
}

/// Used to decode JSON friends array for Friend entity
struct FriendProperties: Decodable, Hashable {
    let id: String
    let name: String
}
