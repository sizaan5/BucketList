//
//  ContentView.swift
//  BucketList
//
//  Created by Izaan Saleem on 07/10/2024.
//

import SwiftUI

struct User: Comparable, Identifiable {
    let id = UUID()
    var firstName: String
    var lastName: String
    
    static func <(lhs: User, rhs: User) -> Bool {
        lhs.lastName < rhs.lastName
    }
}

struct ContentView: View {
    let users: [User] = [
        .init(firstName: "Izaan", lastName: "Saleem"),
        .init(firstName: "Paul", lastName: "Hudson"),
        .init(firstName: "Jane", lastName: "Wick"),
    ].sorted()
    
    var body: some View {
        List(users) { user in
            Text("\(user.firstName) \(user.lastName)")
        }
    }
}

#Preview {
    ContentView()
}
