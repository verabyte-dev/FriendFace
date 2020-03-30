//
//  FriendView.swift
//  FriendFace
//
//  Created by Jeffrey Williams on 3/28/20.
//  Copyright © 2020 Jeffrey Williams. All rights reserved.
//

import SwiftUI
import CoreData

struct FriendView: View {
    var fetchRequest: FetchRequest<User>
    var friendData: FetchedResults<User> { fetchRequest.wrappedValue }
    let friend: Friend
    
    var body: some View {
        Form {
            Section(header: Text("Bio:")) {
                DetailLine(label: "Age", text: "\(friendData.first?.age ?? 0)")
                DetailLine(label: "Company", text: friendData.first?.company ?? "No data")
                DetailLine(label: "Address", text: friendData.first?.address ?? "No data")
                DetailLine(label: "Email", text: friendData.first?.email ?? "No data")
                DetailLine(label: "About", text: friendData.first?.about ?? "No data")
            }

            Section(header: Text("Status:")) {
                DetailLine(label: "Active?", text: friendData.first?.isActive ?? false ? "Yes" : "No")
                DetailLine(label: "Registered", text: friendData.first?.registered?.format() ?? "No data")
            }

            Section(header: Text("Tags:")) {
                Text(tagArray())
            }
        }
        .navigationBarTitle(Text(friend.wrappedName), displayMode: .automatic)
    }
    
    init(friend: Friend) {
        self.friend = friend
        fetchRequest = FetchRequest<User>(entity: User.entity(), sortDescriptors: [], predicate: NSPredicate(format: "id LIKE %@", friend.wrappedId))
    }
    
    func tagArray() -> String {
        var tagString = ""
        guard let tagArray = friendData.first?.tagArray else { return "" }
        var tagCount = 0
        for tag in tagArray {
            tagCount += 1
            tagString.append(tag.wrappedTag)
            if tagCount != tagArray.count {
                tagString.append(", ")
            }
        }
        return tagString
    }
}

struct FriendView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let friend = Friend(context: self.moc)
        friend.id = "50a48fa3-2c0f-4397-ac50-64da464f9954"
        friend.name = "Test Friend"
        
        return NavigationView {
            FriendView(friend: friend)
        }
    }
}
