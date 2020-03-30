//
//  ContentView.swift
//  FriendFace
//
//  Created by Jeffrey Williams on 3/28/20.
//  Copyright © 2020 Jeffrey Williams. All rights reserved.
//

import CoreData
import SwiftUI

extension Date {
    func format() -> String {
        let formatter = DateFormatter()
        formatter.locale = Calendar.current.locale
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: User.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \User.name, ascending: true)
            ]) var users: FetchedResults<User>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(users, id: \.self) { user in
                    NavigationLink(destination: DetailView(user: user)) {
                        VStack(alignment: .leading) {
                            Text(user.wrappedName)
                                .font(.headline)
                            Text(user.wrappedCompany)
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationBarItems(leading: Button(action: loadData) { Text("Load") }, trailing: Button(action: deleteData) { Text("Delete") })
            .navigationBarTitle(Text("Friendface"))
        }
    }
    
    func decodeData(data: Data) {
        var userPropertiesArray = [UserProperties]()
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let decoded = try decoder.decode([UserProperties].self, from: data)
            userPropertiesArray.append(contentsOf: decoded)
            updateCoreData(with: userPropertiesArray)
        } catch {
            print("Error decoding JSON User data!")
        }
    }
    
    func deleteData() {
        for user in users {
            moc.delete(user)
        }
        saveData()
    }
    
    func deleteUser(at offsets: IndexSet) {
        for offset in offsets {
            let user = users[offset]
            moc.delete(user)
        }
        saveData()
    }
    
    func loadData() {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid URL")
            return
        }
                
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    self.decodeData(data: data)
                }
            } else if let error = error {
                print("Error fetching data: \(error.localizedDescription)!")
            }
        }.resume()
    }
    
    func saveData() {
        if self.moc.hasChanges {
            print("Saving data...")
            do {
                try self.moc.save()
            } catch {
                print("Error saving core data!")
            }
        }
    }
    
    func updateCoreData(with userPropertiesArray: [UserProperties]) {
        for userData in userPropertiesArray {
            let user = User(context: moc)
            user.id = userData.id
            user.name = userData.name
            user.isActive = userData.isActive
            user.age = Int16(userData.age)
            user.company = userData.company
            user.email = userData.email
            user.address = userData.address
            user.about = userData.about
            user.registered = userData.registered
           
            for userTag in userData.tags {
                let tag = Tag(context: moc)
                tag.tag = userTag
                tag.origin = user
                user.addToTag(tag)
            }
            
            for userFriend in userData.friends {
                let friend = Friend(context: moc)
                friend.id = userFriend.id
                friend.name = userFriend.name
                friend.origin = user
                user.addToFriend(friend)
            }
        }
        
        saveData()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
