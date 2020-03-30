//
//  Tag+CoreDataProperties.swift
//  FriendFace
//
//  Created by Jeffrey Williams on 3/28/20.
//  Copyright © 2020 Jeffrey Williams. All rights reserved.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var tag: String?
    @NSManaged public var origin: User?
    
    public var wrappedTag: String {
        tag ?? "Unknown tag"
    }
}
