//
//  UserError.swift
//  FriendFace
//
//  Created by Jeffrey Williams on 3/29/20.
//  Copyright © 2020 Jeffrey Williams. All rights reserved.
//

import Foundation

enum UserError: Error {
    case urlError
    case networkUnavailable
    case wrongDataFormat
    case missingData
    case creationError
}

extension UserError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .urlError:
            return NSLocalizedString("Could not create a URL.", comment: "")
        case .networkUnavailable:
            return NSLocalizedString("Could not get data from the remote server.", comment: "")
        case .wrongDataFormat:
            return NSLocalizedString("Could not digest the fetched data.", comment: "")
        case .missingData:
            return NSLocalizedString("Found and will discard a User missing a valid id or name.", comment: "")
        case .creationError:
            return NSLocalizedString("Failed to create a new User object.", comment: "")
        }
    }
}
