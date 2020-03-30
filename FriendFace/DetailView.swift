//
//  DetailView.swift
//  FriendFace
//
//  Created by Jeffrey Williams on 3/28/20.
//  Copyright © 2020 Jeffrey Williams. All rights reserved.
//

import SwiftUI
import CoreData

/// Formats date to String using medium format
extension Date {
    func format() -> String {
        let formatter = DateFormatter()
        formatter.locale = Calendar.current.locale
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}

struct DetailLine: View {
    let label: String
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("\(label):")
                .foregroundColor(Color.secondary)
            Text(text)
        }
    }
}

struct DetailView: View {
    let user: User
    
    var body: some View {
        Form {
            Section(header: Text("Bio:")) {
                DetailLine(label: "Age", text: "\(user.age)")
                DetailLine(label: "Company", text: user.wrappedCompany)
                DetailLine(label: "Address", text: user.wrappedAddress)
                DetailLine(label: "Email", text: user.wrappedEmail)
                DetailLine(label: "About", text: user.wrappedAbout)
            }
            
            Section(header: Text("Status:")) {
                DetailLine(label: "Active?", text: user.isActive ? "Yes" : "No")
                DetailLine(label: "Registered", text: user.registered?.format() ?? "Unknown")
            }

            Section(header: Text("Tags:")) {
                Text(tagArray())
            }

            Section(header: Text("Friends:")) {
                ForEach(user.friendArray.sorted(by: {$0.wrappedName < $1.wrappedName}), id: \.self) { friend in
                    NavigationLink(destination: FriendView(friend: friend)) {
                        Text(friend.wrappedName)
                    }
                }
            }
        }
        .navigationBarTitle(Text(user.wrappedName), displayMode: .automatic)
    }
        
    /// Returns a String containing all the tags separated with a comma
    func tagArray() -> String {
        var tagString = ""
        var tagCount = 0
        for tag in user.tagArray {
            tagCount += 1
            tagString.append(tag.wrappedTag)
            if tagCount != user.tagArray.count {
                tagString.append(", ")
            }
        }
        return tagString
    }

}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let user = User(context: self.moc)
        user.name = "Test User"
        user.company = "Some Company"
        user.address = "Some Address, Some City, CA 01234"
        user.email = "testuser@mail.com"
        user.age = 27
        user.about = "I'm just a test user."
        user.isActive = true
        user.registered = Date()
        
        return NavigationView {
            DetailView(user: user)
        }
    }
}
